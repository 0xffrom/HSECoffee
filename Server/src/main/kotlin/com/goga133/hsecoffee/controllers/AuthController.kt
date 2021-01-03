package com.goga133.hsecoffee.controllers

import com.goga133.hsecoffee.service.EmailService
import com.goga133.hsecoffee.service.JwtService
import com.goga133.hsecoffee.service.RefreshTokenService
import com.goga133.hsecoffee.service.UserService
import org.springframework.beans.factory.annotation.Autowired
import org.springframework.http.HttpStatus
import org.springframework.http.ResponseEntity
import org.springframework.stereotype.Controller
import org.springframework.web.bind.annotation.RequestMapping
import org.springframework.web.bind.annotation.RequestMethod
import org.springframework.web.bind.annotation.RequestParam
import org.springframework.web.bind.annotation.ResponseStatus
import java.util.*


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
            return ResponseEntity.status(HttpStatus.BAD_REQUEST).body("Некорректный домен почты")
        }

        if (emailService.trySendCode(email)) {
            return ResponseEntity.ok("Код был выслан")
        }

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
            val user =
                userService?.getUserByEmailOrCreate(email) ?: return ResponseEntity(
                    "Server error",
                    HttpStatus.INTERNAL_SERVER_ERROR
                )

            return ResponseEntity.ok(
                jwtService?.getJsonTokens(user, fingerprint) ?: return ResponseEntity(
                    "Server error",
                    HttpStatus.INTERNAL_SERVER_ERROR
                )
            )
        }

        return ResponseEntity.badRequest().body("Некорректный код или email.")
    }

    /**
     * Метод для обновления пары Refresh - Access токенов.
     * POST запрос по адресу /api/refresh.
     *
     * @param email - email адрес пользователя.
     * @param refreshToken - Refresh Token пользовотеля, представляет из себя UUID.
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
                .body("Пользователя с такой почтой не существует.")

        if (refreshTokenService?.isValid(user, refreshToken, fingerprint) == true) {
            return ResponseEntity.ok(
                jwtService?.getJsonTokens(user, fingerprint) ?: return ResponseEntity(
                    "Server error",
                    HttpStatus.INTERNAL_SERVER_ERROR
                )
            )
        }

        return ResponseEntity.badRequest().body("Невозможно обновить токен.")
    }
}

