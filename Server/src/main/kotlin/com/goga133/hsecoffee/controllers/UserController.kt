package com.goga133.hsecoffee.controllers

import com.fasterxml.jackson.module.kotlin.jacksonObjectMapper
import com.goga133.hsecoffee.objects.Sex
import com.goga133.hsecoffee.objects.User
import com.goga133.hsecoffee.service.ImageStorageService
import com.goga133.hsecoffee.service.JwtService
import com.goga133.hsecoffee.service.UserService
import io.jsonwebtoken.ExpiredJwtException
import io.jsonwebtoken.JwtException
import org.springframework.beans.factory.annotation.Autowired
import org.springframework.beans.factory.annotation.Value
import org.springframework.boot.json.JsonParserFactory
import org.springframework.context.annotation.PropertySource
import org.springframework.http.HttpStatus
import org.springframework.http.ResponseEntity
import org.springframework.stereotype.Controller
import org.springframework.web.bind.annotation.*
import org.springframework.web.multipart.MultipartFile
import java.io.IOException
import java.lang.IllegalArgumentException

@Controller
class UserController {
    @Autowired
    private val jwtService: JwtService? = null

    @Autowired
    private val userService: UserService? = null

    @Autowired
    private val imageStorageService: ImageStorageService? = null

    @RequestMapping(value = ["/api/user/settings/{token}"], method = [RequestMethod.PUT])
    @ResponseStatus(HttpStatus.OK)
    fun setSettings(@PathVariable("token") token: String, @RequestBody newUser: User): ResponseEntity<User?> {
        val email: String

        try {
            val claim = jwtService?.validateAccessToken(token)

            if (claim?.body?.subject == null)
                return ResponseEntity.badRequest().build()
            else
                email = claim.body.subject
        } catch (e: ExpiredJwtException) {
            return ResponseEntity.status(HttpStatus.FORBIDDEN).body(null)
        } catch (e: JwtException) {
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body(null)
        }

        val user = userService?.getUserByEmail(email)

        if (user == null) {
            return ResponseEntity.status(HttpStatus.NOT_FOUND).body(null)
        } else {
            user.setParams(newUser)
            userService?.save(user)
        }


        return ResponseEntity.ok(user)
    }

    @RequestMapping(value = ["/api/user/settings/{token}"], method = [RequestMethod.GET])
    @ResponseStatus(HttpStatus.OK)
    fun getSettings(@PathVariable("token") token: String): ResponseEntity<String> {
        val email: String

        try {
            val claim = jwtService?.validateAccessToken(token)

            if (claim?.body?.subject == null)
                return ResponseEntity.badRequest().build()
            else
                email = claim.body.subject
        } catch (e: ExpiredJwtException) {
            return ResponseEntity.status(HttpStatus.FORBIDDEN).body("The token has expired.")
        } catch (e: JwtException) {
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body("Incorrect token")
        }

        val user = userService?.getUserByEmail(email) ?: return ResponseEntity.status(HttpStatus.BAD_GATEWAY)
            .body("Server error")


        return ResponseEntity.ok(jacksonObjectMapper().writeValueAsString(user))
    }

    @RequestMapping(value = ["/api/user/image/{token}"], method = [RequestMethod.POST])
    fun setImage(
        @PathVariable("token") token: String,
        @RequestParam("image") image: MultipartFile
    ): ResponseEntity<String> {
        val email: String

        try {
            val claim = jwtService?.validateAccessToken(token)

            if (claim?.body?.subject == null)
                return ResponseEntity.badRequest().build()
            else
                email = claim.body.subject
        } catch (e: ExpiredJwtException) {
            return ResponseEntity.status(HttpStatus.FORBIDDEN).body("The token has expired")
        } catch (e: JwtException) {
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body("Incorrect token")
        }

        if (imageStorageService?.correctFile(image) == false) {
            return ResponseEntity.status(HttpStatus.BAD_REQUEST).body("Bad image")
        }

        try {
            imageStorageService?.store(image, email)
        } catch (ioException: IOException) {
            return ResponseEntity.status(HttpStatus.FORBIDDEN).body("Server error")
        }
        return ResponseEntity.ok("Success")
    }
}

