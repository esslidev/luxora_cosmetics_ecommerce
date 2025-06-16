import { PrismaClient, User } from '@prisma/client'
import { Request, Response } from 'express'
import * as jwt from 'jsonwebtoken'
import { HttpError } from '../core/resources/response/httpError'
import { handleError } from '../core/utils/errorHandler'
import {
  addSecondsToDate,
  decryptData,
  encryptData,
  getJwtExpiryTime,
  isEmailValid,
  isPasswordValid,
  saltAndHashData,
  verifyHashedData,
} from '../core/utils/utils'
import CustomResponse from '../core/resources/response/customResponse'
import { HttpStatusCode } from '../core/enums/response/httpStatusCode'
import { errorResponse } from '../core/resources/response/localizedErrorResponse'
import { mailSender } from '../core/utils/mailSender'
import path from 'path'

const prisma = new PrismaClient()

const storeName = process.env.STORE_NAME
const rightsYear = process.env.RIGHTS_YEAR
const frontendUrl = process.env.FRONTEND_URL

const logoPath = path.join(__dirname, '../../assets/PNG/logo.png')
const accountCreatedTemplatePath = path.join(__dirname, '../../src/views/accountCreatedTemplate.hbs')
const resetPasswordTemplatePath = path.join(__dirname, '../../src/views/resetPasswordTemplate.hbs')
const passwordChangedTemplatePath = path.join(__dirname, '../../src/views/passwordChangedTemplate.hbs')

const jwtSecretToken = process.env.JWT_SECRET_ACCESS
const jwtSecretRenewToken = process.env.JWT_SECRET_RENEW
const jwtSecretPasswordResetToken = process.env.JWT_SECRET_PASSWORD_RESET
const jwtSecretEmailVerificationToken = process.env.JWT_SECRET_EMAIL_VERIFICATION

const accessTokenLifeSpan = process.env.ACCESS_TOKEN_LIFESPAN
const renewTokenLifeSpan = process.env.RENEW_TOKEN_LIFESPAN
const passwordResetTokenLifeSpan = process.env.RESET_PASSWORD_TOKEN_LIFESPAN
const emailVerificationTokenLifeSpan = process.env.EMAIL_VERIFICATION_TOKEN_LIFESPAN

const signUp = async (req: Request, res: Response) => {
  const { language, email, phone, password, firstName, lastName, addressMain, addressSecond, city, zip } = req.body

  try {
    if (!email || !isEmailValid(email)) {
      throw new HttpError(
        HttpStatusCode.BAD_REQUEST,
        errorResponse(language).errorTitle.INVALID_EMAIL,
        errorResponse(language).errorMessage.INVALID_EMAIL
      )
    }

    if (!password || !isPasswordValid(password)) {
      throw new HttpError(
        HttpStatusCode.BAD_REQUEST,
        errorResponse(language).errorTitle.INVALID_PASSWORD,
        errorResponse(language).errorMessage.INVALID_PASSWORD
      )
    }

    if (!phone || !password || !firstName || !lastName || !addressMain || !city || !zip) {
      throw new HttpError(
        HttpStatusCode.BAD_REQUEST,
        errorResponse(language).errorTitle.MISSING_PARAMETERS,
        errorResponse(language).errorMessage.MISSING_PARAMETERS
      )
    }

    const encryptedEmail = await encryptData(email.toLowerCase())
    const encryptedPhone = await encryptData(phone.toLowerCase())
    const hashedPassword = await saltAndHashData(password)
    const encryptedFirstName = await encryptData(firstName.toLowerCase())
    const encryptedLastName = await encryptData(lastName.toLowerCase())
    const encryptedAddressMain = await encryptData(addressMain.toLowerCase())
    const encryptedAddressSecond = await encryptData(addressSecond.toLowerCase())

    const existingUser = await prisma.user.findUnique({
      where: { encryptedEmail: encryptedEmail },
    })

    if (existingUser) {
      throw new HttpError(
        HttpStatusCode.BAD_REQUEST,
        errorResponse(language).errorTitle.USER_ALREADY_EXISTS,
        errorResponse(language).errorMessage.USER_ALREADY_EXISTS
      )
    }

    const user = await prisma.user.create({
      data: {
        encryptedEmail,
        encryptedPhone,
        hashedPassword,
        encryptedFirstName,
        encryptedLastName,
        encryptedAddressMain,
        encryptedAddressSecond,
        city,
        zip,
      },
    })

    if (!jwtSecretToken || !jwtSecretRenewToken) {
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

    const tokenPayload = {
      userId: user.id,
      isAdmin: user.isAdmin,
    }

    const accessToken = jwt.sign(tokenPayload, jwtSecretToken, {
      expiresIn: getJwtExpiryTime(accessTokenLifeSpan),
    })
    const renewToken = jwt.sign(tokenPayload, jwtSecretRenewToken, {
      expiresIn: getJwtExpiryTime(renewTokenLifeSpan),
    })

    await prisma.sessions.create({
      data: {
        userId: user.id,
        accessToken,
        renewToken,
        accessTokenExpiryTime: addSecondsToDate(new Date(), getJwtExpiryTime(accessTokenLifeSpan) ?? 0),
        renewTokenExpiryTime: addSecondsToDate(new Date(), getJwtExpiryTime(renewTokenLifeSpan) ?? 0),
      },
    })

    mailSender(
      email,
      storeName + ' | Votre compte a bien été créé',
      undefined,
      accountCreatedTemplatePath,
      {
        username: decryptData(user.encryptedFirstName ?? ''),
        storeName: storeName,
        frontendUrl: frontendUrl,
      },
      [
        {
          filename: 'logo.png',
          path: logoPath,
          cid: 'logo',
        },
      ]
    )

    new CustomResponse(res).send({ data: { accessToken, renewToken } })
  } catch (error) {
    handleError(error, res, language)
  }
}

const signIn = async (req: Request, res: Response) => {
  const { language, email, password } = req.body

  try {
    if (email && !isEmailValid(email)) {
      throw new HttpError(
        HttpStatusCode.BAD_REQUEST,
        errorResponse(language).errorTitle.INVALID_EMAIL,
        errorResponse(language).errorMessage.INVALID_EMAIL
      )
    }

    if (password && !isPasswordValid(password)) {
      throw new HttpError(
        HttpStatusCode.BAD_REQUEST,
        errorResponse(language).errorTitle.INVALID_PASSWORD,
        errorResponse(language).errorMessage.INVALID_PASSWORD
      )
    }

    const encryptedEmail = encryptData(email.toLowerCase())
    const user = await prisma.user.findUnique({
      where: { encryptedEmail },
    })

    if (user && !(await verifyHashedData(password, user.hashedPassword))) {
      throw new HttpError(
        HttpStatusCode.UNAUTHORIZED,
        errorResponse(language).errorTitle.INVALID_CREDENTIALS,
        errorResponse(language).errorMessage.INVALID_CREDENTIALS,
        {
          accessUnauthorized: true,
        }
      )
    }

    if (!user) {
      throw new HttpError(
        HttpStatusCode.UNAUTHORIZED,
        errorResponse(language).errorTitle.INVALID_SIGNIN_DATA,
        errorResponse(language).errorMessage.INVALID_SIGNIN_DATA
      )
    }

    if (!jwtSecretToken || !jwtSecretRenewToken) {
      console.error('JWT secret tokens are not configured properly in the environment variables.')
      throw new HttpError(
        HttpStatusCode.INTERNAL_SERVER_ERROR,
        errorResponse(language).errorTitle.INTERNAL_SERVER_ERROR,
        errorResponse(language).errorMessage.INTERNAL_SERVER_ERROR
      )
    }

    const tokenPayload = {
      userId: user.id,
      isAdmin: user.isAdmin,
    }

    const finalAccessToken = jwt.sign(tokenPayload, jwtSecretToken, {
      expiresIn: getJwtExpiryTime(accessTokenLifeSpan),
    })

    const finalRenewToken = jwt.sign(tokenPayload, jwtSecretRenewToken, {
      expiresIn: getJwtExpiryTime(renewTokenLifeSpan),
    })

    await prisma.sessions.upsert({
      where: { userId: user.id },
      update: {
        accessTokenExpiryTime: addSecondsToDate(new Date(), getJwtExpiryTime(accessTokenLifeSpan) ?? 0),
        renewTokenExpiryTime: addSecondsToDate(new Date(), getJwtExpiryTime(renewTokenLifeSpan) ?? 0),
        updatedAt: new Date(),
      },
      create: {
        userId: user.id,
        accessToken: finalAccessToken,
        renewToken: finalRenewToken,
        accessTokenExpiryTime: addSecondsToDate(new Date(), getJwtExpiryTime(accessTokenLifeSpan) ?? 0),
        renewTokenExpiryTime: addSecondsToDate(new Date(), getJwtExpiryTime(renewTokenLifeSpan) ?? 0),
      },
    })

    new CustomResponse(res).send({ data: { accessToken: finalAccessToken, renewToken: finalRenewToken } })
  } catch (error) {
    handleError(error, res, language)
  }
}

const signOut = async (req: Request, res: Response) => {
  const { language, userId } = req.body
  try {
    const existingSession = await prisma.sessions.findUnique({
      where: { userId: userId },
    })

    if (!existingSession) {
      throw new HttpError(
        HttpStatusCode.NOT_FOUND,
        errorResponse(language).errorTitle.NOT_FOUND,
        errorResponse(language).errorMessage.NOT_FOUND
      )
    }

    await prisma.sessions.delete({
      where: { userId: userId },
    })

    // Send success response for deletion
    new CustomResponse(res).send({ message: 'L\'utilisateur s\'est déconnecté avec succès.' })
  } catch (error) {
    handleError(error, res, language)
  }
}

const requestPasswordReset = async (req: Request, res: Response) => {
  const { language, email } = req.body

  try {
    // Validate email
    if (!isEmailValid(email)) {
      throw new HttpError(
        HttpStatusCode.BAD_REQUEST,
        errorResponse(language).errorTitle.INVALID_EMAIL,
        errorResponse(language).errorMessage.INVALID_EMAIL
      )
    }

    // Find user by email
    const encryptedEmail = encryptData(email.toLowerCase())
    const user = await prisma.user.findUnique({ where: { encryptedEmail, deletedAt: null } })

    if (!user) {
      throw new HttpError(
        HttpStatusCode.NOT_FOUND,
        errorResponse(language).errorTitle.USER_NOT_FOUND,
        errorResponse(language).errorMessage.USER_NOT_FOUND
      )
    }

    if (!jwtSecretPasswordResetToken) {
      console.error('JWT password reset token secret is not configured.')
      throw new HttpError(
        HttpStatusCode.INTERNAL_SERVER_ERROR,
        errorResponse(language).errorTitle.INTERNAL_SERVER_ERROR,
        errorResponse(language).errorMessage.INTERNAL_SERVER_ERROR
      )
    }

    // Create password reset token
    const resetToken = jwt.sign({ userId: user.id }, jwtSecretPasswordResetToken, {
      expiresIn: getJwtExpiryTime(passwordResetTokenLifeSpan),
    })

    console.log('reset token>> ' + resetToken)

    // Send email with the reset link
    const resetLink = `${frontendUrl}/reset-password?token=${resetToken}`
    mailSender(
      email,
      storeName + ' | Demande de réinitialisation du mot de passe',
      undefined,
      resetPasswordTemplatePath,
      {
        username: decryptData(user.encryptedFirstName ?? ''),
        storeName: storeName,
        year: '2025',
        resetLink: resetLink,
        frontendUrl: frontendUrl,
      },
      [
        {
          filename: 'logo.png',
          path: logoPath,
          cid: 'logo',
        },
      ]
    )

    new CustomResponse(res).send({ message: 'La demande a été envoyée avec succès, veuillez vérifier votre e-mail.' })
  } catch (error) {
    handleError(error, res, language)
  }
}

const resetPassword = async (req: Request, res: Response) => {
  const { language, token, newPassword } = req.body

  try {
    console.log('token>> ' + token)
    console.log('newPassword>> ' + newPassword)
    // Validate new password
    if (!token || !isPasswordValid(newPassword)) {
      throw new HttpError(
        HttpStatusCode.BAD_REQUEST,
        errorResponse(language).errorTitle.INVALID_PASSWORD,
        errorResponse(language).errorMessage.INVALID_PASSWORD
      )
    }

    if (!jwtSecretPasswordResetToken) {
      console.error('JWT password reset token secret is not configured.')
      throw new HttpError(
        HttpStatusCode.INTERNAL_SERVER_ERROR,
        errorResponse(language).errorTitle.INTERNAL_SERVER_ERROR,
        errorResponse(language).errorMessage.INTERNAL_SERVER_ERROR
      )
    }

    let decodedToken
    try {
      decodedToken = jwt.verify(token, jwtSecretPasswordResetToken) as jwt.JwtPayload
    } catch (err) {
      // Handle specific JWT errors
      if (err instanceof jwt.TokenExpiredError) {
        throw new HttpError(
          HttpStatusCode.UNAUTHORIZED,
          errorResponse(language).errorTitle.EXPIRED_TOKEN,
          errorResponse(language).errorMessage.EXPIRED_TOKEN
        )
      } else {
        throw new HttpError(
          HttpStatusCode.UNAUTHORIZED,
          errorResponse(language).errorTitle.INVALID_TOKEN,
          errorResponse(language).errorMessage.INVALID_TOKEN
        )
      }
      // Other JWT errors can be handled as needed
      throw err // Re-throw unexpected errors
    }

    const userId = decodedToken.userId

    // Find user
    const user = await prisma.user.findUnique({ where: { id: userId, deletedAt: null } })
    if (!user) {
      throw new HttpError(
        HttpStatusCode.NOT_FOUND,
        errorResponse(language).errorTitle.USER_NOT_FOUND,
        errorResponse(language).errorMessage.USER_NOT_FOUND
      )
    }

    // Hash the new password and update the user's password
    const hashedPassword = await saltAndHashData(newPassword)
    await prisma.user.update({
      where: { id: userId },
      data: { hashedPassword },
    })

    // Send password changed email
    mailSender(
      decryptData(user.encryptedEmail),
      storeName + ' | Mot de passe modifié',
      undefined,
      passwordChangedTemplatePath,
      {
        username: decryptData(user.encryptedFirstName ?? ''),
        storeName: storeName,
        year: rightsYear,
        frontendUrl: frontendUrl,
      },
      [
        {
          filename: 'logo.png',
          path: logoPath,
          cid: 'logo',
        },
      ]
    )

    new CustomResponse(res).send({ message: 'Votre mot de passe a été modifié avec succès.' })
  } catch (error) {
    handleError(error, res, language)
  }
}

const renewAccess = async (req: Request, res: Response) => {
  const { language, renewToken } = req.body
  try {
    if (!renewToken) {
      throw new HttpError(
        HttpStatusCode.BAD_REQUEST,
        errorResponse().errorTitle.LACK_OF_CREDENTIALS,
        errorResponse().errorMessage.LACK_OF_CREDENTIALS
      )
    }

    if (!jwtSecretRenewToken) {
      console.error('JWT secret renew token is not configured properly in the environment variables.')
      throw new HttpError(
        HttpStatusCode.INTERNAL_SERVER_ERROR,
        errorResponse(language).errorTitle.INTERNAL_SERVER_ERROR,
        errorResponse(language).errorMessage.INTERNAL_SERVER_ERROR
      )
    }

    let decodedResult
    try {
      decodedResult = jwt.verify(renewToken, jwtSecretRenewToken) as jwt.JwtPayload
    } catch (err) {
      // Handle specific JWT errors
      if (err instanceof jwt.TokenExpiredError) {
        throw new HttpError(
          HttpStatusCode.UNAUTHORIZED,
          errorResponse().errorTitle.RENEW_TOKEN_EXPIRED,
          errorResponse().errorMessage.EXPIRED_TOKEN,
          {
            expiredRenewToken: true,
          }
        )
      }
      // Other JWT errors can be handled as needed
      throw err // Re-throw unexpected errors
    }

    // Extract userId from decoded renew token
    const userId = decodedResult.userId
    const userRole = decodedResult.userRole

    if (!jwtSecretToken) {
      console.error('JWT secret tokens are not configured properly in the environment variables.')
      throw new HttpError(
        HttpStatusCode.INTERNAL_SERVER_ERROR,
        errorResponse(language).errorTitle.INTERNAL_SERVER_ERROR,
        errorResponse(language).errorMessage.INTERNAL_SERVER_ERROR
      )
    }

    // Generate new access token
    const tokenPayload = { userId: userId, userRole: userRole }
    const finalAccessToken = jwt.sign(tokenPayload, jwtSecretToken, {
      expiresIn: getJwtExpiryTime(accessTokenLifeSpan),
    })

    new CustomResponse(res).send({ data: { accessToken: finalAccessToken } })
  } catch (error) {
    handleError(error, res, language)
  }
}

module.exports = {
  signUp,
  signIn,
  requestPasswordReset,
  resetPassword,
  signOut,
  renewAccess,
}
