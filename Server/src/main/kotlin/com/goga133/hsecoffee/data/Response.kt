package com.goga133.hsecoffee.data

import org.springframework.http.HttpStatus

/**
 * Data class. Предназначается для сервисов, чтобы отдать контроллеру уже готовый ответ в случае ошибки.
 */
data class Response(val httpStatus: HttpStatus, val message: String, val email: String?)
