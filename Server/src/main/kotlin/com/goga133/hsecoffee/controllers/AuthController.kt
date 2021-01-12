package com.goga133.hsecoffee.controllers

import com.goga133.hsecoffee.service.EmailService
import com.goga133.hsecoffee.service.JwtService
import com.goga133.hsecoffee.service.RefreshTokenService
import com.goga133.hsecoffee.service.UserService
import org.slf4j.Logger
import org.slf4j.LoggerFactory
import org.springframework.beans.factory.annotation.Autowired
import org.springframework.http.HttpStatus
import org.springframework.http.ResponseEntity
import org.springframework.stereotype.Controller
import org.springframework.web.bind.annotation.RequestMapping
import org.springframework.web.bind.annotation.RequestMethod
import org.springframework.web.bind.annotation.RequestParam
import org.springframework.web.bind.annotation.ResponseStatus
import java.util.*
import kotlin.math.log


/**
 * Контроллер для авторизации пользователя.
 * Авторизация может происходить только через код, высланный на Email с доменами @edu.hse.ru или @hse.ru.
 * @see com.goga133.hsecoffee.entity.ConfirmationCode
 * После подтверждения Email-кода, пользователю высылается пара JWT из access Token и refresh Token.
 * AccessToken - многоразовый токен, но кратковременный.
 * RefreshToken - одноразовый токен, но долгосрочный.
 * @see com.goga133.hsecoffee.entity.RefreshToken
 * Пользователь также может получить AccessToken, отправив свой RefreshToken и fingerprint.
 * fingerprint - некий отпечаток устройства, можно называть его идентификатором.
 */
@Controller
class AuthController {
    /**
     * Логгер.
     */
    private val logger: Logger = LoggerFactory.getLogger(AuthController::class.java)

    /**
     * Сервис для работы с SMTP.
     */
    @Autowired
    private val emailService: EmailService? = null

    /**
     * Сервис для работы с пользователями.
     */
    @Autowired
    private val userService: UserService? = null

    /**
     * Сервис для работы с JWT.
     */
    @Autowired
    private val jwtService: JwtService? = null

    /**
     * Сервис для работы с RefreshToken
     */
    @Autowired
    private val refreshTokenService: RefreshTokenService? = null

    /**
     * Метод для отправки Email-кода на почту пользователя.
     * POST запрос по адресу /api/code.
     *
     *
     * @param email - email адрес пользователя.
     * @return HTTP-ответ с телом из описания ответа сервера.
     */
    @RequestMapping(value = ["/api/code"], method = [RequestMethod.POST])
    fun sendCode(@RequestParam(value = "email") email: String): ResponseEntity<String> {
        // Проверка на валидность почты:
        if (emailService?.isValidMail(email) != true) {
            val message = "Некорректный домен почты."

            logger.info("Код не был отправлен на $email. Причина: $message")
            return ResponseEntity.status(HttpStatus.BAD_REQUEST).body(message)
        }

        if (emailService.trySendCode(email)) {
            logger.info("Код был выслан на $email.")
            return ResponseEntity.ok("Код был выслан")
        }

        logger.debug("Ошибка. Не удалось отправить код на $email.")
        // Если не удалось отослать письмо:
        return ResponseEntity.status(HttpStatus.BAD_REQUEST).body("Не удалось отправить код")
    }

    /**
     * Метод для подтверждения кода, присланного на почту пользоваля.
     * POST запрос по адресу /api/confirm.
     *
     *
     * @param email - email адрес пользователя.
     * @param code - код с почты.
     * @param fingerprint - уникальный идентификатор устройства.
     * @return HTTP-ответ с телом из JSON двух строковых полей (токенов) или описанием ошибки.
     */
    @RequestMapping(value = ["/api/confirm"], method = [RequestMethod.POST])
    fun confirmCode(
        @RequestParam email: String,
        @RequestParam code: Int,
        @RequestParam fingerprint: String
    ): ResponseEntity<String> {
        if (emailService?.isValidCode(email, code) == true) {
            val user = userService?.getUserByEmailOrCreate(email) ?: return ResponseEntity(
                "Incorrect email",
                HttpStatus.BAD_REQUEST
            ).also {
                logger.debug("Пользователь с email = $email не был найден.")
            }


            return ResponseEntity.ok(
                jwtService?.getJsonTokens(user, fingerprint).also {
                    logger.info("Пользовать с email = $email подтвердил учётную запись.")
                } ?: return ResponseEntity(
                    "Server error",
                    HttpStatus.INTERNAL_SERVER_ERROR
                ).also {
                    logger.warn(
                        "Возникла серверная ошибка при получении токенов." +
                                "Email = $email; Code = $code; fingerprint = $fingerprint.\""
                    )
                }
            )
        }
        logger.info("Код $code не является валидным для $email.")
        return ResponseEntity.badRequest().body("Некорректный код или email.")
    }

    /**
     * Метод для обновления пары Refresh - Access токенов.
     * POST запрос по адресу /api/refresh.
     *
     * @param email - email адрес пользователя.
     * @param refreshToken - Refresh Token пользовотеля, представляет из себя [UUID].
     * @param fingerprint - уникальный идентификатор устройства.
     * @return HTTP-ответ с телом из JSON двух строковых полей (токенов) или описанием ошибки.
     */
    @RequestMapping(value = ["/api/refresh"], method = [RequestMethod.POST])
    @ResponseStatus(HttpStatus.OK)
    fun refreshToken(
        @RequestParam email: String,
        @RequestParam refreshToken: UUID,
        @RequestParam fingerprint: String
    ): ResponseEntity<String> {
        // Если user == null, значит пользователя нет в БД, а значит операция невозможна.
        val user = userService?.getUserByEmail(email)
            ?: return ResponseEntity.badRequest()
                .body("Пользователя с такой почтой не существует.").also {
                    logger.debug("Пользователь с email = $email не найден.")
                }

        if (refreshTokenService?.isValid(user, refreshToken, fingerprint) == true) {
            return ResponseEntity.ok(
                jwtService?.getJsonTokens(user, fingerprint).also {
                    logger.info("Пользователь $user обновил RefreshToken.")
                } ?: return ResponseEntity(
                    "Server error",
                    HttpStatus.INTERNAL_SERVER_ERROR
                ).also {
                    logger.warn("Пользователю $user не удалось обновить RefreshToken.")
                }
            )
        }

        logger.debug("Обновитель Refresh Token для user = $user невозможно. Данные некорректные.")

        return ResponseEntity.badRequest().body("Невозможно обновить токен.")
    }
}

