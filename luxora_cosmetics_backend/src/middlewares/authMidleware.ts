import { Request, Response, NextFunction } from 'express'
import { HttpError } from '../core/resources/response/httpError'
import * as jwt from 'jsonwebtoken'
import { handleError } from '../core/utils/errorHandler'
import { HttpStatusCode } from '../core/enums/response/httpStatusCode'
import { errorResponse } from '../core/resources/response/localizedErrorResponse'
import { PrismaClient } from '@prisma/client'

const prisma = new PrismaClient()

const envApiKey = process.env.API_SECRET_KEY
const jwtSecretToken = process.env.JWT_SECRET_ACCESS

export const integrationAuthMiddleware = async (req: Request, res: Response, next: NextFunction) => {
  const apiKey = req.headers.apikey
  const language: any = req.headers.language
  try {
    console.log(language)
    if (!apiKey) {
      throw new HttpError(
        HttpStatusCode.UNAUTHORIZED,
        errorResponse(language).errorTitle.LACK_OF_CREDENTIALS,
        errorResponse(language).errorMessage.LACK_OF_CREDENTIALS
      )
    }

    if (apiKey != envApiKey) {
      throw new HttpError(
        HttpStatusCode.UNAUTHORIZED,
        errorResponse(language).errorTitle.INVALID_CREDENTIALS,
        errorResponse(language).errorMessage.INVALID_CREDENTIALS
      )
    }
    req.body = {
      ...req.body,
      language: language,
      userId: null,
      isAdmin: null,
    }

    next()
  } catch (error) {
    handleError(error, res, language)
  }
}

export const authMiddleware = async (req: Request, res: Response, next: NextFunction) => {
  const language: any = req.headers.language
  const accessToken = req.headers.authorization
  try {
    if (!accessToken) {
      throw new HttpError(
        HttpStatusCode.UNAUTHORIZED,
        errorResponse(language).errorTitle.AUTHENTICATION_ERROR,
        errorResponse(language).errorMessage.LACK_OF_CREDENTIALS,
        {
          accessUnauthorized: true,
        }
      )
    }

    // Validate secret token
    if (!jwtSecretToken) {
      console.error('JWT secret tokens are not configured properly in the environment variables.')
      throw new HttpError(
        HttpStatusCode.INTERNAL_SERVER_ERROR,
        errorResponse(language).errorTitle.INTERNAL_SERVER_ERROR,
        errorResponse(language).errorMessage.INTERNAL_SERVER_ERROR,
        {
          accessUnauthorized: true,
        }
      )
    }

    let decodedResult
    try {
      decodedResult = jwt.verify(accessToken, jwtSecretToken) as jwt.JwtPayload
    } catch (err) {
      // Handle specific JWT errors
      if (err instanceof jwt.TokenExpiredError) {
        throw new HttpError(
          HttpStatusCode.UNAUTHORIZED,
          errorResponse(language).errorTitle.ACCESS_TOKEN_EXPIRED,
          errorResponse(language).errorMessage.EXPIRED_TOKEN,
          {
            expiredAccessToken: true,
          }
        )
      }
      // Other JWT errors can be handled as needed
      throw err // Re-throw unexpected errors
    }

    // Attach userId and userRole to req.body
    req.body = {
      ...req.body,
      language: language,
      userId: decodedResult.userId,
      isAdmin: decodedResult.isAdmin,
    }
    next()
  } catch (error) {
    handleError(error, res, language)
  }
}

export const isAdminMiddleware = async (req: Request, res: Response, next: NextFunction) => {
  const language: any = req.headers.language
  const userId = req.body.userId
  try {
    // Fetch the user from the database
    const user = await prisma.user.findUnique({ where: { id: userId, isAdmin: true, deletedAt: null } })

    if (!user) {
      throw new HttpError(
        HttpStatusCode.FORBIDDEN,
        errorResponse(language).errorTitle.UNAUTHORIZED_ACCESS,
        errorResponse(language).errorMessage.UNAUTHORIZED_ACCESS,
        {
          accessUnauthorized: true,
        }
      )
    }
    next()
  } catch (error) {
    handleError(error, res, language)
  }
}

export const isVerifiedMiddleware = async (req: Request, res: Response, next: NextFunction) => {
  const language: any = req.headers.language
  const userId = req.body.userId
  try {
    // Fetch the user from the database
    const user = await prisma.user.findUnique({ where: { id: userId, isVerified: true, deletedAt: null } })

    if (!user) {
      throw new HttpError(
        HttpStatusCode.FORBIDDEN,
        errorResponse(language).errorTitle.EMAIL_NOT_VERIFIED,
        errorResponse(language).errorMessage.EMAIL_NOT_VERIFIED
      )
    }

    next()
  } catch (error) {
    handleError(error, res, language)
  }
}
