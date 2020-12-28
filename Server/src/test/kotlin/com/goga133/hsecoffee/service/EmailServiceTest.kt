package com.goga133.hsecoffee.service

import com.goga133.hsecoffee.objects.ConfirmationCode
import com.goga133.hsecoffee.repository.ConfirmationCodeRepository
import org.junit.Assert.assertFalse
import org.junit.Assert.assertTrue
import org.junit.jupiter.api.Test
import org.junit.runner.RunWith
import org.springframework.beans.factory.annotation.Autowired
import org.springframework.boot.test.autoconfigure.jdbc.AutoConfigureTestDatabase
import org.springframework.boot.test.autoconfigure.orm.jpa.DataJpaTest
import org.springframework.boot.test.autoconfigure.orm.jpa.TestEntityManager
import org.springframework.mail.javamail.JavaMailSenderImpl
import org.springframework.test.context.ContextConfiguration
import org.springframework.test.context.junit4.AbstractJUnit4SpringContextTests
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner
import org.springframework.test.context.junit4.SpringRunner


@DataJpaTest
@AutoConfigureTestDatabase(replace = AutoConfigureTestDatabase.Replace.NONE)
@RunWith(SpringJUnit4ClassRunner::class)
internal class EmailServiceTest{

    @Autowired
    private val entityManager: TestEntityManager? = null

    @Autowired
    val confirmationCodeRepository: ConfirmationCodeRepository? = null

    @Autowired
    val emailService : EmailService? = null

    @Test
    fun isValid() {
        emailService?.isValid("test@test", 1)?.let { assertFalse(it) }

        confirmationCodeRepository?.save(ConfirmationCode("test@test", 1))
        entityManager?.persist(ConfirmationCode("test@test", 1))

        emailService?.isValid("test@test", 1)?.let { assertTrue(it) }
    }


    fun isValidWithTime() {
        val emailServiceLong = EmailService(JavaMailSenderImpl(), "", "", "", 1)

        assertFalse(emailServiceLong.isValid("test1@test", 1))

        confirmationCodeRepository?.save(ConfirmationCode("test1@test", 1))

        assertFalse(emailServiceLong.isValid("test1@test", 1))
    }

/*    @Test
    fun trySendCode() {
    }*/
}