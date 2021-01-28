package com.goga133.hsecoffee.service

import com.goga133.hsecoffee.entity.User
import org.junit.Assert.assertEquals
import org.junit.Assert.assertNotEquals
import org.junit.jupiter.api.Assertions.assertDoesNotThrow
import org.junit.jupiter.api.Assertions.assertThrows
import org.junit.jupiter.api.Test
import org.junit.runner.RunWith
import org.springframework.boot.test.context.SpringBootTest
import org.springframework.test.context.junit4.SpringRunner

@RunWith(SpringRunner::class)
@SpringBootTest
internal class JwtServiceTest {

    private val mockSecretKey : String = "rXDm2ZfPA8kvi+luLS2+mYTOPzCr+FUC/SLGpehOtgd4TZstuH6COLA2aaUhY2HcoXj8lolkekTES/A6EYUQHA=="
    private val jwtService = JwtService(mockSecretKey, 60)

    @Test
    fun createJwt() {
        val mockUser = User("test@test")
        val key = jwtService.createAccessToken(mockUser)

        assertEquals(key.split(".")[0], "eyJhbGciOiJIUzUxMiJ9")
        assertNotEquals(
            key.split(".")[1],
            "eyJzdWIiOiJ0ZXN0QHRlc3QiLCJpc3MiOiJIU0UgQ29mZmVlIiwiZXhwIjoxNjA4MTE1MTA2LCJpYXQiOjE2MDgxMTMzMDZ9"
        )

        assertDoesNotThrow {
            val valid = jwtService.parseAccessToken(key)

            assertEquals(valid.body.subject, "test@test")
        }
    }

    @Test
    fun validateJwt() {
        val mockUser = User("test@test")
        val key = jwtService.createAccessToken(mockUser)

        assertDoesNotThrow {
            jwtService.parseAccessToken(key)
        }

        assertThrows(io.jsonwebtoken.security.SignatureException::class.java) {
            jwtService.parseAccessToken(key + "z")
        }
        assertThrows(io.jsonwebtoken.MalformedJwtException::class.java) {
            jwtService.parseAccessToken("$key.")
        }
    }
}