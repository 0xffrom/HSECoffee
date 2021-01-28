package com.goga133.hsecoffee.data.wrappers

import org.springframework.http.HttpStatus

/**
 * Data class. Предназначается для JWT, чтобы отдать контроллеру уже готовый ответ в случае ошибки.
 */
data class JwtResponseWrapper(val httpStatus: HttpStatus, val message: String, val email: String?)
