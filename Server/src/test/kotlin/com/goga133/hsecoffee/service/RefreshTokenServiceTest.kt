package com.goga133.hsecoffee.service

import com.goga133.hsecoffee.objects.ConfirmationCode
import com.goga133.hsecoffee.objects.User
import com.goga133.hsecoffee.repository.ConfirmationCodeRepository
import org.junit.Assert.assertFalse
import org.junit.Assert.assertTrue
import org.junit.jupiter.api.Test
import org.junit.runner.RunWith
import org.springframework.beans.factory.annotation.Autowired
import org.springframework.boot.test.autoconfigure.jdbc.AutoConfigureTestDatabase
import org.springframework.boot.test.autoconfigure.orm.jpa.DataJpaTest
import org.springframework.boot.test.autoconfigure.orm.jpa.TestEntityManager
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner
import java.util.*
import java.util.concurrent.TimeUnit
import kotlin.random.Random

@RunWith(SpringJUnit4ClassRunner::class)
internal class RefreshTokenServiceTest {

    @Autowired
    val refreshTokenService: RefreshTokenService? = null

    @Test
    fun createByUserAndValidate() {
        val mockUser: User = User("test@test")
        val fingerprint: String = "mock_fingerprint"

        val refreshToken = refreshTokenService!!.createByUser(mockUser, fingerprint)

        // Неверный UUID и fingerprint.
        assertFalse(refreshTokenService!!.isValid(mockUser, UUID.randomUUID(), "finger"))
        // Неверный fingerprint
        assertFalse(refreshTokenService!!.isValid(mockUser, refreshToken.uuid, "finger"))
        // Неверный UUID. WARNING: В редких случаях может совпасть UUID.
        assertFalse(refreshTokenService!!.isValid(mockUser, UUID.randomUUID(), refreshToken.fingerprint))
        // Всё верно
        assertTrue(refreshTokenService!!.isValid(mockUser, refreshToken.uuid, refreshToken.fingerprint))
        // Старые данные
        assertTrue(refreshTokenService!!.isValid(mockUser, refreshToken.uuid, refreshToken.fingerprint))
    }
}