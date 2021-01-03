package com.goga133.hsecoffee.controllers

import com.fasterxml.jackson.module.kotlin.jacksonObjectMapper
import com.goga133.hsecoffee.entity.User
import com.goga133.hsecoffee.service.ImageStorageService
import com.goga133.hsecoffee.service.JwtService
import com.goga133.hsecoffee.service.UserService
import org.springframework.beans.BeanUtils
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
    fun setSettings(@PathVariable("token") token: String, @RequestBody user: User): ResponseEntity<String> {
        // Если валидация прошла неуспешно - возвращаем код ошибки от валидатора:
        val validator = jwtService?.validateToken(token).apply {
            if (this?.httpStatus != HttpStatus.OK)
                return ResponseEntity.status(this?.httpStatus ?: HttpStatus.BAD_REQUEST).body(this?.message)
        }
        // Читаем Email после валидации:
        val email: String =
            validator?.email ?: return ResponseEntity("Возникла ошибка при валидации токена.", HttpStatus.BAD_REQUEST)

        // Пользователь из БД:
        val userDb = userService?.getUserByEmail(email) ?: return ResponseEntity.status(HttpStatus.NOT_FOUND).body(null)

        with(userDb) {
            // Копируем текущего пользователя в пользователя БД:
            BeanUtils.copyProperties(user, this, "id", "createdDate", "email")

            // Сохраняем
            userService.save(this)

            return ResponseEntity.ok(jacksonObjectMapper().writeValueAsString(this))
        }
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
    fun getSettings(@PathVariable("token") token: String): ResponseEntity<String> {
        // Если валидация прошла неуспешно - возвращаем код ошибки от валидатора:
        val validator = jwtService?.validateToken(token).apply {
            if (this?.httpStatus != HttpStatus.OK)
                return ResponseEntity.status(this?.httpStatus ?: HttpStatus.BAD_REQUEST).body(this?.message)
        }
        // Читаем Email после валидации:
        val email: String =
            validator?.email ?: return ResponseEntity.status(HttpStatus.BAD_REQUEST)
                .body("Возникла ошибка при валидации токена.")

        val user = userService?.getUserByEmail(email) ?: return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
            .body("Возникла серверная ошибка.")


        return ResponseEntity.ok(jacksonObjectMapper().writeValueAsString(user))
    }

    /**
     * Метод для загрузки фотографии пользователя.
     * Максимальный объём выставлен в поле@code{spring.servlet.multipart.max-file-size}
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
    ): ResponseEntity<String> {
        // Если валидация прошла неуспешно - возвращаем код ошибки от валидатора:
        val validator = jwtService?.validateToken(token).apply {
            if (this?.httpStatus != HttpStatus.OK)
                return ResponseEntity.status(this?.httpStatus ?: HttpStatus.BAD_REQUEST).body(this?.message)
        }
        // Читаем Email после валидации:
        val email: String = validator?.email ?: return ResponseEntity.status(HttpStatus.BAD_REQUEST)
            .body("Возникла ошибка при валидации токена.")


        if (imageStorageService?.correctFile(image) == false) {
            return ResponseEntity.status(HttpStatus.BAD_REQUEST).body("Некорректная фотография.")
        }

        try {
            imageStorageService?.store(
                image,
                userService?.getUserByEmail(email) ?: return ResponseEntity.status(HttpStatus.BAD_REQUEST)
                    .body("Неверная почта.")
            )
        } catch (ioException: IOException) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body("Серверная ошибка.")
        }

        return ResponseEntity.ok("Успешно.")
    }

}

