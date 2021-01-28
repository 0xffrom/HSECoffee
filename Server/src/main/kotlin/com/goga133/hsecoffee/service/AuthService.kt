package com.goga133.hsecoffee.service

import com.goga133.hsecoffee.data.wrappers.LoginWrapper
import org.slf4j.Logger
import org.slf4j.LoggerFactory
import org.springframework.beans.factory.annotation.Autowired
import org.springframework.http.HttpStatus
import org.springframework.http.ResponseEntity
import org.springframework.stereotype.Service

@Service
class AuthService {
    /**
     * Логгер.
     */
    private val logger: Logger = LoggerFactory.getLogger(AuthService::class.java)


    /**
     * Сервис для работы с JWT.
     */
    @Autowired
    private val jwtService: JwtService? = null

    /**
     * Сервис для работы с пользователями.
     */
    @Autowired
    private val userService: UserService? = null


    fun logByToken(token: String): LoginWrapper {
        // Если валидация прошла неуспешно - возвращаем код ошибки от валидатора:
        val validator = jwtService?.validateToken(token).apply {
            if (this?.httpStatus != HttpStatus.OK) {
                logger.debug("Неверный токен: token = $token. Ошибка: ${this?.message}")
                return LoginWrapper(
                    responseEntity = ResponseEntity.status(this?.httpStatus ?: HttpStatus.BAD_REQUEST)
                        .body(this?.message)
                )
            }

        }
        // Читаем Email после валидации:
        val email: String =
            validator?.email ?: return LoginWrapper(
                responseEntity = ResponseEntity.status(HttpStatus.BAD_REQUEST)
                    .body("Возникла ошибка при валидации токена.")
            )

        val user = userService?.getUserByEmail(email) ?: return LoginWrapper(
            responseEntity = ResponseEntity.status(HttpStatus.BAD_REQUEST)
                .body("Возникла серверная ошибка")
        )
            .apply { logger.warn("При верном token = $token пользователя не существует.") }

        return LoginWrapper(user = user)
    }
}