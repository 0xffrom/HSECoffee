package com.goga133.hsecoffee.service

import com.goga133.hsecoffee.entity.User
import org.junit.Assert.assertFalse
import org.junit.Assert.assertTrue
import org.junit.jupiter.api.Test
import org.junit.runner.RunWith
import org.springframework.beans.factory.annotation.Autowired
import org.springframework.boot.test.context.SpringBootTest
import org.springframework.test.context.junit4.SpringRunner
import java.util.*
import javax.transaction.Transactional

@RunWith(SpringRunner::class)
@SpringBootTest
@Transactional
internal class RefreshTokenServiceTest {

    @Autowired
    val userService : UserService? = null

    @Autowired
    val refreshTokenService: RefreshTokenService? = null

    @Test
    fun createByUserAndValidate() {
        val mockUser: User = User("test@test")
        val fingerprint: String = "mock_fingerprint"

        userService?.save(mockUser)

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