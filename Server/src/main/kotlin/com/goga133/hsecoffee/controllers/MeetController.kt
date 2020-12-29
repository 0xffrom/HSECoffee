package com.goga133.hsecoffee.controllers

import com.goga133.hsecoffee.service.EmailService
import com.goga133.hsecoffee.service.JwtService
import com.goga133.hsecoffee.service.UserService
import io.jsonwebtoken.ExpiredJwtException
import io.jsonwebtoken.JwtException
import org.springframework.beans.factory.annotation.Autowired
import org.springframework.http.HttpStatus
import org.springframework.http.ResponseEntity
import org.springframework.stereotype.Controller
import org.springframework.web.bind.annotation.RequestMapping
import org.springframework.web.bind.annotation.RequestMethod
import org.springframework.web.bind.annotation.RequestParam
import org.springframework.web.bind.annotation.ResponseStatus

@Controller
class MeetController {
    @Autowired
    private val jwtService: JwtService? = null

    @Autowired
    private val userService: UserService? = null


    @RequestMapping(value = ["/api/meet"], method = [RequestMethod.GET])
    fun getMeet(): ResponseEntity<String> {

    }

    @RequestMapping(value = ["/api/meet"], method = [RequestMethod.POST])
    fun findMeet(): ResponseEntity<String> {

    }

    @RequestMapping(value = ["/api/meet"], method = [RequestMethod.DELETE])
    fun stopMeet(): ResponseEntity<String> {

    }


    /**
     * Валидация токена
     */
    private fun validateToken(token: String): ResponseEntity<String> {
        val email: String

        try {
            val claim = jwtService?.validateAccessToken(token)

            if (claim?.body?.subject == null)
                return ResponseEntity.status(HttpStatus.PAYLOAD_TOO_LARGE)
                    .body("Incorrect token structure")
            else
                email = claim.body.subject
        } catch (e: ExpiredJwtException) {
            return ResponseEntity.status(HttpStatus.FORBIDDEN).body("The token has expired")
        } catch (e: JwtException) {
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body("Incorrect token")
        }

        return ResponseEntity.ok(email)
    }

}