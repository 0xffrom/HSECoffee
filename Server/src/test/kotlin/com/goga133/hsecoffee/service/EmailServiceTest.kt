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
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner
import java.util.concurrent.TimeUnit
import kotlin.random.Random


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
    fun is_correct_validator_by_exist() {
        val mockCode : Int =  Random.nextInt()
        emailService?.isValid("test@test$mockCode", mockCode)?.let { assertFalse(it) }

        entityManager?.persist(ConfirmationCode("test@test$mockCode", mockCode))

        emailService?.isValid("test@test$mockCode", mockCode)?.let { assertTrue(it) }
    }

    @Test
    fun is_correct_validator_by_time() {
        val mockCode : Int =  Random.nextInt()

        emailService?.setLifeTime(1).let {
            TimeUnit.MILLISECONDS.sleep(10)
        }

        emailService?.isValid("test@test$mockCode", 1)?.let { assertFalse(it) }

        confirmationCodeRepository?.save(ConfirmationCode("test@test$mockCode",  mockCode))

        entityManager?.persist(ConfirmationCode("test@test$mockCode",  mockCode))

        emailService?.isValid("test@test$mockCode", mockCode)?.let { assertFalse(it) }
    }
}