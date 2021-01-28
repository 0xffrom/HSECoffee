package com.goga133.hsecoffee.controllers

import com.fasterxml.jackson.module.kotlin.jacksonObjectMapper
import com.goga133.hsecoffee.entity.User
import com.goga133.hsecoffee.service.AuthService
import com.goga133.hsecoffee.service.ImageStorageService
import com.goga133.hsecoffee.service.UserService
import org.slf4j.Logger
import org.slf4j.LoggerFactory
import org.springframework.beans.factory.annotation.Autowired
import org.springframework.http.HttpStatus
import org.springframework.http.ResponseEntity
import org.springframework.stereotype.Controller
import org.springframework.web.bind.annotation.*
import org.springframework.web.multipart.MultipartFile
import java.io.IOException


/**
 * Контроллер для управления аккаунтом пользователя.
 * Пользователь может выставлять настройки, получать текущии, а также загружать фотографию.
 * Пользователь не может выставлять себе следующие поля: id, email, createdDate.
 */
@Controller
class UserController {
    /**
     * Логгер.
     */
    private val logger: Logger = LoggerFactory.getLogger(UserController::class.java)

    /**
     * Сервис для работы с авторизацией
     */
    @Autowired
    private val authService: AuthService? = null

    /**
     * Сервис для работы с пользователями.
     */
    @Autowired
    private val userService: UserService? = null

    /**
     * Сервис для работы с загрузкой фотографий.
     */
    @Autowired
    private val imageStorageService: ImageStorageService? = null


    /**
     * Метод для выставления настроек для пользователя.
     * Пользователь не может выставлять себе следующие поля: id, email, createdDate.
     * PUT запрос по адресу /api/user/settings/{token}, где token - access токен пользователя.
     *
     * @return HTTP-ответ с телом из JSON представления объекта пользователя или описания ошибки.
     * @see com.goga133.hsecoffee.entity.User
     */
    @RequestMapping(value = ["/api/user/settings/{token}"], method = [RequestMethod.PUT])
    fun setSettings(@PathVariable("token") token: String, @RequestBody newUser: User): ResponseEntity<String>? {
        val loginWrapper = authService?.logByToken(token)

        if(loginWrapper?.isSuccessful() != true){
            return loginWrapper?.responseEntity
        }

        if(userService?.setSettings(loginWrapper.user!!, newUser) == true){
            logger.info("Пользователю $newUser обновлены настройки.")
            return ResponseEntity.ok(jacksonObjectMapper().writeValueAsString(this))
        }

        logger.warn("С пользователем $newUser возникла ошибка при обновлении настроек.")

        return ResponseEntity.badRequest().body("Возникла ошибка.")

    }

    /**
     * Метод получения текущих настроек пользователя.
     * GET запрос по адресу /api/user/settings/{token}, где token - access токен пользователя.
     *
     * @return HTTP-ответ с телом из JSON представления объекта пользователя или описания ошибки.
     * @see com.goga133.hsecoffee.entity.User
     */
    @RequestMapping(value = ["/api/user/settings/{token}"], method = [RequestMethod.GET])
    @ResponseStatus(HttpStatus.OK)
    fun getSettings(@PathVariable("token") token: String): ResponseEntity<String>? {
        val loginWrapper = authService?.logByToken(token)

        if(loginWrapper?.isSuccessful() != true){
            return loginWrapper?.responseEntity
        }

        val user = loginWrapper.user!!

        logger.info("Выданы настройки для пользователя $user")
        return ResponseEntity.ok(jacksonObjectMapper().writeValueAsString(user))
    }

    /**
     * Метод для загрузки фотографии пользователя.
     * Максимальный объём выставлен в поле [properties.spring.servlet.multipart.max-file-size]
     *
     * POST по адресу /api/user/image/{token}, где token - access токен пользователя.
     *
     * @param image - фотография, загружаемая пользователем.
     * @return HTTP-ответ с телом из JSON представления объекта пользователя или описания ошибки.
     * @see com.goga133.hsecoffee.entity.User
     */
    @RequestMapping(value = ["/api/user/image/{token}"], method = [RequestMethod.POST])
    fun setImage(
        @PathVariable("token") token: String,
        @RequestParam("image") image: MultipartFile
    ): ResponseEntity<String>? {
        val loginWrapper = authService?.logByToken(token)

        if(loginWrapper?.isSuccessful() != true){
            return loginWrapper?.responseEntity
        }

        val user = loginWrapper.user!!

        if (imageStorageService?.correctFile(image) == false) {
            logger.debug("Пользователь $user заслал некорректный файл.")
            return ResponseEntity.status(HttpStatus.BAD_REQUEST).body("Некорректная фотография.")
        }

        try {
            imageStorageService?.store(image, user)
        } catch (ioException: IOException) {
            logger.error("Произошла ошибка при работе с файловой системой.", ioException)
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body("Серверная ошибка.")
        }

        logger.info("Польватель $user успешно загрузил фотографию размером в ${image.size} байт.")
        return ResponseEntity.ok("Успешно.")
    }

}

