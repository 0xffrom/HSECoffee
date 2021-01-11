package com.goga133.hsecoffee.controllers

import com.fasterxml.jackson.module.kotlin.jacksonObjectMapper
import com.goga133.hsecoffee.data.status.CancelStatus
import com.goga133.hsecoffee.data.status.MeetStatus
import com.goga133.hsecoffee.entity.SearchParams
import com.goga133.hsecoffee.service.JwtService
import com.goga133.hsecoffee.service.MeetService
import com.goga133.hsecoffee.service.UserService
import org.slf4j.Logger
import org.slf4j.LoggerFactory
import org.springframework.beans.factory.annotation.Autowired
import org.springframework.http.HttpStatus
import org.springframework.http.ResponseEntity
import org.springframework.stereotype.Controller
import org.springframework.web.bind.annotation.PathVariable
import org.springframework.web.bind.annotation.RequestBody
import org.springframework.web.bind.annotation.RequestMapping
import org.springframework.web.bind.annotation.RequestMethod
import kotlin.math.log

/**
 * Контроллер для управления встречами авторизованных пользователей.
 * Авторизованный пользователь может получать статус его текущей встречи, выполнять поиск или отменять его встречи
 * по параметрам, а также получать список завершённых встреч.
 */
@Controller
class MeetController {
    /**
     * Логгер.
     */
    val logger: Logger = LoggerFactory.getLogger(MeetController::class.java)

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
     * Сервис для работы с встречами.
     */
    @Autowired
    private val meetService: MeetService? = null

    /**
     * Метод для получения текущей встречи, если её нет возвращается неизвестная встреча с @code{"MeetStatus.NONE"}
     * GET запрос по адресу /api/meet/{token}, где token - access токен пользователя.
     *
     * @return HTTP-ответ с телом из JSON представления объекта встречи или описания ошибки.
     * @see com.goga133.hsecoffee.entity.Meet
     */
    @RequestMapping(value = ["/api/meet/{token}"], method = [RequestMethod.GET])
    fun getMeet(@PathVariable("token") token: String): ResponseEntity<String> {
        // Если валидация прошла неуспешно - возвращаем код ошибки от валидатора:
        val validator = jwtService?.validateToken(token).apply {
            if (this?.httpStatus != HttpStatus.OK) {
                logger.debug("Неверный токен: token = $token. Ошибка: ${this?.message}")
                return ResponseEntity.status(this?.httpStatus ?: HttpStatus.BAD_REQUEST).body(this?.message)
            }

        }
        // Читаем Email после валидации:
        val email: String =
            validator?.email ?: return ResponseEntity.status(HttpStatus.BAD_REQUEST)
                .body("Возникла ошибка при валидации токена.")


        val user = userService?.getUserByEmail(email) ?: return ResponseEntity.status(HttpStatus.BAD_REQUEST)
            .body("Возникла серверная ошибка")
            .apply { logger.warn("При верном token = $token пользователя не существует.") }


        // Получаем встречу, если получить не удалось - возвращаем ошибку.
        val meet = meetService?.getMeet(user)

        logger.info("Для user = $user встреча равна $meet")
        // Если встреча успешно получена - возращаем её JSON представление.
        return ResponseEntity.ok(jacksonObjectMapper().writeValueAsString(meet))
    }

    /**
     * Метод для начала поиска встречи. Если встреча была уже начата - возвращается @code{MeetStatus.ACTIVE},
     * если же встреча уже ищется - @code{MeetStatus.SEARCH}, если произошла ошибка - @code{MeetStatus.ERROR}
     * GET запрос по адресу /api/meet/{token}, где token - access токен пользователя.
     *
     * @param searchParams - Body из JSON объекта SearchParams
     * @return HTTP-ответ с телом из MeetStatus или описания ошибки.
     * @see com.goga133.hsecoffee.entity.SearchParams
     * @see com.goga133.hsecoffee.entity.Meet
     */
    @RequestMapping(value = ["/api/meet/{token}"], method = [RequestMethod.POST])
    fun findMeet(
        @PathVariable("token") token: String,
        @RequestBody searchParams: SearchParams
    ): ResponseEntity<String> {
        // Если валидация прошла неуспешно - возвращаем код ошибки от валидатора:
        val validator = jwtService?.validateToken(token).apply {
            if (this?.httpStatus != HttpStatus.OK) {
                logger.debug("Неверный токен: token = $token. Ошибка: ${this?.message}")
                return ResponseEntity.status(this?.httpStatus ?: HttpStatus.BAD_REQUEST).body(this?.message)
            }

        }
        // Читаем Email после валидации:
        val email: String =
            validator?.email ?: return ResponseEntity.status(HttpStatus.BAD_REQUEST)
                .body("Возникла ошибка при валидации токена.")

        val user = userService?.getUserByEmail(email) ?: return ResponseEntity.status(HttpStatus.BAD_REQUEST)
            .body("Возникла серверная ошибка")
            .apply { logger.warn("При верном token = $token пользователя не существует.") }

        val meetStatus = meetService?.searchMeet(user, searchParams)

        if (meetStatus == MeetStatus.ERROR) {
            return ResponseEntity("Возникла серверная ошибка", HttpStatus.INTERNAL_SERVER_ERROR)
        }

        logger.info("Для user = $user стастус встречи - $meetStatus")
        return ResponseEntity.ok(meetStatus.toString())
    }

    /**
     * Метод для прерывания поиска встречи.
     *
     * DELETE запрос по адресу /api/meet/{token}, где token - access токен пользователя.
     *
     * @return HTTP-ответ с телом из описания серверного ответа.
     * @see com.goga133.hsecoffee.entity.Meet
     */
    @RequestMapping(value = ["/api/meet/{token}"], method = [RequestMethod.DELETE])
    fun cancelSearch(@PathVariable("token") token: String): ResponseEntity<String> {
        // Если валидация прошла неуспешно - возвращаем код ошибки от валидатора:
        val validator = jwtService?.validateToken(token).apply {
            if (this?.httpStatus != HttpStatus.OK) {
                logger.debug("Неверный токен: token = $token. Ошибка: ${this?.message}")
                return ResponseEntity.status(this?.httpStatus ?: HttpStatus.BAD_REQUEST).body(this?.message)
            }

        }

        // Читаем Email после валидации:
        val email: String =
            validator?.email ?: return ResponseEntity.status(HttpStatus.BAD_REQUEST)
                .body("Возникла ошибка при валидации токена.")


        // Получаем пользователя:
        val user = userService?.getUserByEmail(email) ?: return ResponseEntity.status(HttpStatus.BAD_REQUEST)
            .body("Возникла серверная ошибка")
            .apply { logger.warn("При верном token = $token пользователя не существует.") }



        return when (meetService?.cancelSearch(user).also {
            logger.info("Отмена встречи для user = $user прозошла со статусом $it.") }) {
            CancelStatus.SUCCESS -> ResponseEntity.ok("Успешно.")
            else -> ResponseEntity.status(HttpStatus.BAD_REQUEST).body("Невозможно отменить встречу.")
        }
    }

    /**
     * Метод для получения списка из законченный встреч. Законченной встречей считается такая встреча,
     * у которой @code{MeetStatus.FINISHED}
     *
     * DELETE запрос по адресу /api/meet/{token}, где token - access токен пользователя.
     *
     * @return HTTP-ответ с телом из описания серверного ответа.
     * @see com.goga133.hsecoffee.entity.Meet
     */
    @RequestMapping(value = ["/api/meets/{token}"], method = [RequestMethod.GET])
    fun getMeets(@PathVariable("token") token: String): ResponseEntity<String> {
        // Если валидация прошла неуспешно - возвращаем код ошибки от валидатора:
        val validator = jwtService?.validateToken(token).apply {
            if (this?.httpStatus != HttpStatus.OK) {
                logger.debug("Неверный токен: token = $token. Ошибка: ${this?.message}")
                return ResponseEntity.status(this?.httpStatus ?: HttpStatus.BAD_REQUEST).body(this?.message)
            }

        }
        // Читаем Email после валидации:
        val email: String =
            validator?.email ?: return ResponseEntity.status(HttpStatus.BAD_REQUEST)
                .body("Возникла ошибка при валидации токена.")

        val user = userService?.getUserByEmail(email) ?: return ResponseEntity.status(HttpStatus.BAD_REQUEST)
            .body("Возникла серверная ошибка")
            .apply { logger.warn("При верном token = $token пользователя не существует.") }


        // Список встреч:
        val meets = meetService?.getMeets(user)

        logger.info("Встречи для пользователя user = $user => $meets")
        return ResponseEntity.ok(jacksonObjectMapper().writeValueAsString(meets))
    }
}