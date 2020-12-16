package com.goga133.hsecoffee.service

import com.goga133.hsecoffee.objects.User
import org.junit.jupiter.api.Test

import org.junit.jupiter.api.Assertions.*

internal class JwtServiceTest {

    private val mockSecretKey : String = "ugfhsVQeAnQQT0JwS7Nl23RorZ/xv6M+sCHd5SATfp8="

    @Test
    fun createJwt() {
        val mockUser = User("test@test")
        val key = JwtService(mockSecretKey).createAccessToken(mockUser)

        assertEquals(key.split(".")[0], "eyJhbGciOiJIUzI1NiJ9")
        assertNotEquals(
            key.split(".")[1],
            "eyJzdWIiOiJ0ZXN0QHRlc3QiLCJpc3MiOiJIU0UgQ29mZmVlIiwiZXhwIjoxNjA4MTE1MTA2LCJpYXQiOjE2MDgxMTMzMDZ9"
        )

        assertDoesNotThrow {
            val valid = JwtService(mockSecretKey).validateAccessToken(key)

            assertEquals(valid.body.subject, "test@test")
        }


    }

    @Test
    fun validateJwt() {
    }
}