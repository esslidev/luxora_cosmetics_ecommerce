import { ArErrorMessage, ArErrorTitle } from '../../enums/response/arErrorResponse'
import { DeErrorMessage, DeErrorTitle } from '../../enums/response/deErrorResponse'
import { EnErrorMessage, EnErrorTitle } from '../../enums/response/enErrorResponse'
import { FrErrorMessage, FrErrorTitle } from '../../enums/response/frErrorResponse'
import { HttpStatusCode } from '../../enums/response/httpStatusCode'

export class HttpError extends Error {
  public statusCode: HttpStatusCode
  public errorTitle: EnErrorTitle | FrErrorTitle | DeErrorTitle | ArErrorTitle | string
  public errorMessage: EnErrorMessage | FrErrorMessage | DeErrorMessage | ArErrorMessage | string
  public expiredAccessToken: boolean
  public expiredRenewToken: boolean
  public accessUnauthorized: boolean

  constructor(
    statusCode: HttpStatusCode,
    errorTitle: EnErrorTitle | FrErrorTitle | DeErrorTitle | ArErrorTitle | string,
    errorMessage: EnErrorMessage | FrErrorMessage | DeErrorMessage | ArErrorMessage | string,
    { expiredAccessToken = false, expiredRenewToken = false, accessUnauthorized = false } = {}
  ) {
    super(errorMessage)
    this.statusCode = statusCode
    this.errorTitle = errorTitle
    this.errorMessage = errorMessage
    this.expiredAccessToken = expiredAccessToken
    this.expiredRenewToken = expiredRenewToken
    this.accessUnauthorized = accessUnauthorized
  }
}
