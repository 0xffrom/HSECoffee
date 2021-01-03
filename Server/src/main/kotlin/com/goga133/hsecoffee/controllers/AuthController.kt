package com.goga133.hsecoffee.controllers

import com.fasterxml.jackson.module.kotlin.jacksonObjectMapper
import com.goga133.hsecoffee.entity.User
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

@Controller
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
     * @return
     */
    @RequestMapping(value = ["/api/code"], method = [RequestMethod.POST])
    fun sendCode(@RequestParam(value = "email") email: String): ResponseEntity<String> {
        if (emailService?.isValidMail(email) != true) {
            return ResponseEntity.status(HttpStatus.BAD_REQUEST).body("Некорректный домен почты")
        }

        if (emailService.trySendCode(email)) {
            return ResponseEntity.ok("Код был выслан")
        }

        return ResponseEntity.status(HttpStatus.BAD_REQUEST).body("Не удалось отправить код")
    }

    @RequestMapping(value = ["/api/confirm"], method = [RequestMethod.POST])
    @ResponseStatus(HttpStatus.OK)
    fun confirmCode(
            @RequestParam email: String,
            @RequestParam code: Int,
            @RequestParam fingerprint: String
    ): ResponseEntity<String> {
        if (emailService?.isValidCode(email, code) == true) {
            val user =
                    userService?.getUserByEmailOrCreate(email)
                            ?: return ResponseEntity.badRequest().body("Server Error")

            return ResponseEntity.ok(getTokensJSON(user, fingerprint))
        }

        return ResponseEntity.badRequest().body("Incorrect code or email.")
    }

    @RequestMapping(value = ["/api/refresh"], method = [RequestMethod.POST])
    @ResponseStatus(HttpStatus.OK)
    fun refreshToken(
            @RequestParam email: String,
            @RequestParam token: UUID,
            @RequestParam fingerPrint: String
    ): ResponseEntity<String> {

        val user = userService?.getUserByEmail(email)
                ?: return ResponseEntity.badRequest()
                        .body("Пользователя с такой почтой не существует.")

        if (refreshTokenService?.isValid(user, token, fingerPrint) == true) {
            return ResponseEntity.ok(getTokensJSON(user, fingerPrint))
        }

        return ResponseEntity.badRequest().body("Невозможно обновить токен.")
    }


    private fun getTokensJSON(user: User, fingerPrint: String): String {
        val accessToken = jwtService?.createAccessToken(user)
        val refreshToken = refreshTokenService?.createByUser(user, fingerPrint)?.uuid

        return jacksonObjectMapper().writeValueAsString(
                mapOf<String, Any?>(
                        "accessToken" to accessToken,
                        "refreshToken" to refreshToken
                )
        )
    }
}

