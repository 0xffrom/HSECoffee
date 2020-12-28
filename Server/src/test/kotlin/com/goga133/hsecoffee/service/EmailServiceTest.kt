package com.goga133.hsecoffee.service

import com.goga133.hsecoffee.HseCoffeeApplication
import com.goga133.hsecoffee.objects.ConfirmationCode
import com.goga133.hsecoffee.repository.ConfirmationCodeRepository
import org.junit.jupiter.api.Assertions.assertFalse
import org.junit.jupiter.api.Assertions.assertTrue

import org.junit.jupiter.api.Test
import org.junit.runner.RunWith
import org.springframework.beans.factory.annotation.Autowired
import org.springframework.boot.test.autoconfigure.jdbc.AutoConfigureTestDatabase
import org.springframework.boot.test.autoconfigure.orm.jpa.DataJpaTest
import org.springframework.boot.test.autoconfigure.orm.jpa.TestEntityManager
import org.springframework.boot.test.context.SpringBootTest
import org.springframework.test.context.ContextConfiguration
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner
import org.springframework.test.context.junit4.SpringRunner
import org.springframework.transaction.annotation.Transactional
import java.util.concurrent.TimeUnit
import kotlin.random.Random


@AutoConfigureTestDatabase(replace = AutoConfigureTestDatabase.Replace.NONE)
@RunWith(SpringRunner::class)
@SpringBootTest
@ContextConfiguration(classes = [HseCoffeeApplication::class])
internal class EmailServiceTest {
    @Autowired
    val confirmationCodeRepository: ConfirmationCodeRepository? = null

    @Autowired
    val emailService: EmailService? = null

    @Test
    fun is_correct_validator_by_exist() {
        val mockCode: Int = Random.nextInt()
        assertFalse(emailService!!.isValid("test@test$mockCode", mockCode))
        confirmationCodeRepository?.save(ConfirmationCode("test@test$mockCode", mockCode))

        assertTrue(emailService!!.isValid("test@test$mockCode", mockCode))
    }

    @Test
    fun is_correct_validator_by_time() {
        val mockCode: Int = Random.nextInt()

        emailService?.setLifeTime(1)
        TimeUnit.MILLISECONDS.sleep(10)

        assertFalse(emailService!!.isValid("test@test$mockCode", mockCode))

        confirmationCodeRepository?.save(ConfirmationCode("test@test$mockCode", mockCode))

        assertFalse(emailService!!.isValid("test@test$mockCode", mockCode))
    }
}