import { Response } from 'express';
import { HttpError } from '../resources/response/httpError';
import { ResponseLanguage } from '../enums/response/responseLanguage';

import { HttpStatusCode } from '../enums/response/httpStatusCode';
import { errorResponse } from '../resources/response/localizedErrorResponse';

// Function to handle errors
const handleError = (error: any, response: Response, language: ResponseLanguage = ResponseLanguage.ENGLISH) => {
  const errorLang = errorResponse(language);  // Get the error response for the specified language

  if (error instanceof HttpError) {
    return response.status(error.statusCode).json({
      error: error.errorTitle,
      message: error.errorMessage,
      expiredAccessToken: error.expiredAccessToken,
      expiredRenewToken: error.expiredRenewToken,
    });
  } else {
    // Log the error
    console.error(error);
    return response.status(HttpStatusCode.INTERNAL_SERVER_ERROR).json({
      error: errorLang.errorTitle.INTERNAL_SERVER_ERROR,
      message: errorLang.errorMessage.INTERNAL_SERVER_ERROR,
    });
  }
};

export { handleError };
