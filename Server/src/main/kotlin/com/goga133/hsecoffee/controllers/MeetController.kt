package com.goga133.hsecoffee.controllers

import com.fasterxml.jackson.module.kotlin.jacksonObjectMapper
import com.goga133.hsecoffee.data.status.CancelStatus
import com.goga133.hsecoffee.data.status.MeetStatus
import com.goga133.hsecoffee.entity.SearchParams
import com.goga133.hsecoffee.service.AuthService
import com.goga133.hsecoffee.service.MeetService
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
    private val logger: Logger = LoggerFactory.getLogger(MeetController::class.java)

    /**
     * Сервис для работы с авторизацией
     */
    @Autowired
    private val authService: AuthService? = null

    /**
     * Сервис для работы с встречами.
     */
    @Autowired
    private val meetService: MeetService? = null

    /**
     * Метод для получения текущей встречи, если её нет возвращается неизвестная встреча с [MeetStatus.NONE]
     * GET запрос по адресу /api/meet/{token}, где token - access токен пользователя.
     *
     * @return HTTP-ответ с телом из JSON представления объекта встречи или описания ошибки.
     * @see com.goga133.hsecoffee.entity.Meet
     */
    @RequestMapping(value = ["/api/meet/{token}"], method = [RequestMethod.GET])
    fun getMeet(@PathVariable("token") token: String): ResponseEntity<String>? {
        val loginWrapper = authService?.logByToken(token)

        if(loginWrapper?.isSuccessful() != true){
            return loginWrapper?.responseEntity
        }

        val user = loginWrapper.user!!


        // Получаем встречу, если получить не удалось - возвращаем ошибку.
        val meet = meetService?.getMeet(user)

        logger.info("Для user = $user встреча равна $meet")
        // Если встреча успешно получена - возращаем её JSON представление.
        return ResponseEntity.ok(jacksonObjectMapper().writeValueAsString(meet))
    }

    /**
     * Метод для начала поиска встречи. Если встреча была уже начата - возвращается [MeetStatus.ACTIVE],
     * если же встреча уже ищется - [MeetStatus.SEARCH], если произошла ошибка - [MeetStatus.ERROR]
     * GET запрос по адресу /api/meet/{token}, где token - access токен пользователя.
     *
     * @param searchParams - Body из JSON объекта SearchParams
     * @return HTTP-ответ с телом из MeetStatus или описания ошибки.
     * @see com.goga133.hsecoffee.entity.SearchParams
     * @see com.goga133.hsecoffee.entity.Meet
     */
    @RequestMapping(value = ["/api/search/{token}"], method = [RequestMethod.POST])
    fun findMeet(
        @PathVariable("token") token: String,
        @RequestBody searchParams: SearchParams
    ): ResponseEntity<String>? {
        // TODO: Добавить для пола

        val loginWrapper = authService?.logByToken(token)

        if(loginWrapper?.isSuccessful() != true){
            return loginWrapper?.responseEntity
        }

        val user = loginWrapper.user!!

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
    fun cancelSearch(@PathVariable("token") token: String): ResponseEntity<String>? {
        val loginWrapper = authService?.logByToken(token)

        if(loginWrapper?.isSuccessful() != true){
            return loginWrapper?.responseEntity
        }

        val user = loginWrapper.user!!

        return when (meetService?.cancelSearch(user).also {
            logger.info("Отмена встречи для user = $user прозошла со статусом $it.") }) {
            CancelStatus.SUCCESS -> ResponseEntity.ok("Успешно.")
            else -> ResponseEntity.status(HttpStatus.BAD_REQUEST).body("Невозможно отменить встречу.")
        }
    }

    /**
     * Метод для получения списка из законченный встреч. Законченной встречей считается такая встреча,
     * у которой [MeetStatus.FINISHED]
     *
     * DELETE запрос по адресу /api/meet/{token}, где token - access токен пользователя.
     *
     * @return HTTP-ответ с телом из описания серверного ответа.
     * @see com.goga133.hsecoffee.entity.Meet
     */
    @RequestMapping(value = ["/api/meets/{token}"], method = [RequestMethod.GET])
    fun getMeets(@PathVariable("token") token: String): ResponseEntity<String>? {
        val loginWrapper = authService?.logByToken(token)

        if(loginWrapper?.isSuccessful() != true){
            return loginWrapper?.responseEntity
        }

        val user = loginWrapper.user!!

        // Список встреч:
        val meets = meetService?.getMeets(user)

        logger.info("Встречи для пользователя user = $user => $meets")
        return ResponseEntity.ok(jacksonObjectMapper().writeValueAsString(meets))
    }
}