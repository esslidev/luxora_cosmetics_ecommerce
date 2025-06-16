import { PrismaClient } from '@prisma/client'
import { Request, Response } from 'express'
import { HttpError } from '../core/resources/response/httpError'
import { handleError } from '../core/utils/errorHandler'
import CustomResponse from '../core/resources/response/customResponse'
import { HttpStatusCode } from '../core/enums/response/httpStatusCode'
import { errorResponse } from '../core/resources/response/localizedErrorResponse'
import { decryptData, encryptData, isPasswordValid, saltAndHashData, verifyHashedData } from '../core/utils/utils'

const prisma = new PrismaClient()

// Update user by ID
const updateUser = async (req: Request, res: Response) => {
  const { language, userId, firstName, lastName, addressMain, addressSecond, city, email, phone, zip } =
    req.body

  try {
    const user = await prisma.user.findUnique({ where: { id: userId, deletedAt: null } })

    if (!user) {
      throw new HttpError(
        HttpStatusCode.NOT_FOUND,
        errorResponse(language).errorTitle.NOT_FOUND,
        errorResponse(language).errorMessage.NOT_FOUND
      )
    }

    const updatedUser = await prisma.user.update({
      where: { id: userId },
      data: {
        ...(firstName && { encryptedFirstName: encryptData(firstName) }),
        ...(lastName && { encryptedLastName: encryptData(lastName) }),
        ...(addressMain && { encryptedAddressMain: encryptData(addressMain) }),
        ...(addressSecond !== undefined && {
          encryptedAddressSecond: addressSecond === '' ? null : encryptData(addressSecond),
        }),
        ...(phone && { encryptedPhone: encryptData(phone) }),
        ...(email && { encryptedEmail: encryptData(email.toLowerCase()) }),
        ...(city && { city }),
        ...(zip && { zip }),
        ...(email != null && { isVerified: false }),
      },
    })

    const responseUser = {
      id: updatedUser.id,
      email: decryptData(updatedUser.encryptedEmail),
      phone: updatedUser.encryptedPhone ? decryptData(updatedUser.encryptedPhone) : null,
      firstName: updatedUser.encryptedFirstName ? decryptData(updatedUser.encryptedFirstName) : null,
      lastName: updatedUser.encryptedLastName ? decryptData(updatedUser.encryptedLastName) : null,
      addressMain: updatedUser.encryptedAddressMain ? decryptData(updatedUser.encryptedAddressMain) : null,
      addressSecond: updatedUser.encryptedAddressSecond ? decryptData(updatedUser.encryptedAddressSecond) : null,
      city: updatedUser.city,
      zip: updatedUser.zip,
    }

    new CustomResponse(res).send({
      data: responseUser,
      message: 'Les données de l\'utilisateur ont été mises à jour avec succès.' + email != null ? ' Une vérification de l\'e-mail est requise.' : '',
    })
  } catch (error) {
    handleError(error, res, language)
  }
}

// Update user email
const updateUserPassword = async (req: Request, res: Response) => {
  const { language, userId, recentPassword, newPassword } = req.body

  try {
    // Fetch the user from the database
    const user = await prisma.user.findUnique({ where: { id: userId, deletedAt: null } })

    // If the user is not found, throw a 404 error
    if (!user) {
      throw new HttpError(
        HttpStatusCode.NOT_FOUND,
        errorResponse(language).errorTitle.NOT_FOUND,
        errorResponse(language).errorMessage.NOT_FOUND
      )
    }

    if (!recentPassword || !newPassword || !isPasswordValid(recentPassword) || !isPasswordValid(newPassword)) {
      throw new HttpError(
        HttpStatusCode.BAD_REQUEST,
        errorResponse(language).errorTitle.INVALID_REQUEST,
        errorResponse(language).errorMessage.INVALID_REQUEST
      )
    }

    // Validate the recent password
    const isRecentPasswordCorrect = await verifyHashedData(recentPassword, user.hashedPassword) // Add a helper function for verification
    if (!isRecentPasswordCorrect) {
      throw new HttpError(
        HttpStatusCode.UNAUTHORIZED,
        errorResponse(language).errorTitle.INVALID_CREDENTIALS,
        errorResponse(language).errorMessage.INVALID_CREDENTIALS
      )
    }

    const hashedNewPassword = await saltAndHashData(newPassword)

    const updatedUser = await prisma.user.update({
      where: { id: userId },
      data: { hashedPassword: hashedNewPassword },
    })

    const responseUser = {
      id: updatedUser.id,
      email: decryptData(updatedUser.encryptedEmail),
      phone: updatedUser.encryptedPhone ? decryptData(updatedUser.encryptedPhone) : null,
      firstName: updatedUser.encryptedFirstName ? decryptData(updatedUser.encryptedFirstName) : null,
      lastName: updatedUser.encryptedLastName ? decryptData(updatedUser.encryptedLastName) : null,
      addressMain: updatedUser.encryptedAddressMain ? decryptData(updatedUser.encryptedAddressMain) : null,
      addressSecond: updatedUser.encryptedAddressSecond ? decryptData(updatedUser.encryptedAddressSecond) : null,
      city: updatedUser.city,
      zip: updatedUser.zip,
    }

    // Send a success response
    new CustomResponse(res).send({
      data: responseUser,
      message: 'Le mot de passe a été mis à jour avec succès.',
    })
  } catch (error) {
    handleError(error, res, language)
  }
}

// Soft delete user by ID
const deleteUser = async (req: Request, res: Response) => {
  const { language, userId } = req.body

  try {
    const user = await prisma.user.findUnique({ where: { id: userId, deletedAt: null } })

    if (!user) {
      throw new HttpError(
        HttpStatusCode.NOT_FOUND,
        errorResponse(language).errorTitle.NOT_FOUND,
        errorResponse(language).errorMessage.NOT_FOUND
      )
    }

    await prisma.user.update({
      where: { id: userId },
      data: { deletedAt: new Date() },
    })

    new CustomResponse(res).send({ message: 'L\'utilisateur a été supprimé avec succès.' })
  } catch (error) {
    handleError(error, res, language)
  }
}

// Get user by userId
const getUser = async (req: Request, res: Response) => {
  const { language, userId } = req.body

  try {
    // Validate input
    if (!userId) {
      throw new HttpError(
        HttpStatusCode.BAD_REQUEST,
        errorResponse(language).errorTitle.INVALID_REQUEST,
        errorResponse(language).errorMessage.INVALID_REQUEST
      )
    }

    // Fetch the user based on filters
    const user = await prisma.user.findFirst({
      where: {
        id: userId,
      },
    })

    // Handle case when user is not found
    if (!user) {
      throw new HttpError(
        HttpStatusCode.NOT_FOUND,
        errorResponse(language).errorTitle.NOT_FOUND,
        errorResponse(language).errorMessage.NOT_FOUND
      )
    }

    // Decrypt user data for response
    const responseUser = {
      id: user.id,
      isAdmin: user.isAdmin,
      email: decryptData(user.encryptedEmail),
      phone: user.encryptedPhone ? decryptData(user.encryptedPhone) : null,
      firstName: user.encryptedFirstName ? decryptData(user.encryptedFirstName) : null,
      lastName: user.encryptedLastName ? decryptData(user.encryptedLastName) : null,
      addressMain: user.encryptedAddressMain ? decryptData(user.encryptedAddressMain) : null,
      addressSecond: user.encryptedAddressSecond ? decryptData(user.encryptedAddressSecond) : null,
      city: user.city,
      zip: user.zip,
    }

    // Send response with user data
    new CustomResponse(res).send({ data: responseUser })
  } catch (error) {
    handleError(error, res, language)
  }
}

// Get all users with optional search and pagination
const getAllUsers = async (req: Request, res: Response) => {
  const { language } = req.body
  const { search, limit = 10, page = 1, orderByAlphabets, includeAdmins } = req.query

  try {
    const take = Number(limit)
    const skip = (Number(page) - 1) * take

    // Define filters for fetching users
    const filters: any = { deletedAt: null }

    // Exclude admin users if includeAdmins is false
    if (!includeAdmins) {
      filters.isAdmin = false
    }

    // Ensure that search is a string
    const searchString = typeof search === 'string' ? search : null

    if (searchString) {
      filters.OR = [
        { encryptedFirstName: { contains: encryptData(searchString) } },
        { encryptedLastName: { contains: encryptData(searchString) } },
        { encryptedEmail: { contains: encryptData(searchString) } },
        { encryptedPhone: { contains: encryptData(searchString) } },
      ]
    }

    // Define order based on query parameter
    const order: any = orderByAlphabets ? { encryptedLastName: 'asc' } : { createdAt: 'desc' }

    // Fetch total count of users matching the filters
    const total = await prisma.user.count({
      where: filters,
    })

    // Fetch paginated users from the database
    const users = await prisma.user.findMany({
      where: filters,
      orderBy: order,
      skip: skip,
      take: take,
    })

    // Decrypt user data for response
    const responseUsers = users.map((user) => ({
      id: user.id,
      isAdmin: user.isAdmin,
      email: decryptData(user.encryptedEmail),
      phone: user.encryptedPhone ? decryptData(user.encryptedPhone) : null,
      firstName: user.encryptedFirstName ? decryptData(user.encryptedFirstName) : null,
      lastName: user.encryptedLastName ? decryptData(user.encryptedLastName) : null,
      addressMain: user.encryptedAddressMain ? decryptData(user.encryptedAddressMain) : null,
      addressSecond: user.encryptedAddressSecond ? decryptData(user.encryptedAddressSecond) : null,
      city: user.city,
      zip: user.zip,
      createdAt: user.createdAt.toISOString(),
      updatedAt: user.updatedAt.toISOString(),
    }))

    // Send response with user data and pagination
    new CustomResponse(res).send({
      data: responseUsers,
      pagination: {
        total,
        page: Number(page),
        pages: Math.ceil(total / take),
      },
    })
  } catch (error) {
    handleError(error, res, language)
  }
}

export { updateUser, updateUserPassword, deleteUser, getAllUsers, getUser }
