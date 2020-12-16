package com.goga133.hsecoffee.service

import com.goga133.hsecoffee.objects.ConfirmationCode
import com.goga133.hsecoffee.objects.User
import com.goga133.hsecoffee.repository.ConfirmationCodeRepository
import com.goga133.hsecoffee.repository.UserRepository
import org.springframework.beans.factory.annotation.Autowired
import org.springframework.beans.factory.annotation.Qualifier
import org.springframework.beans.factory.annotation.Value
import org.springframework.http.ResponseEntity
import org.springframework.mail.SimpleMailMessage
import org.springframework.mail.javamail.JavaMailSender
import org.springframework.stereotype.Service
import java.net.http.HttpResponse
import java.time.Instant
import java.util.*

@Service
class EmailService(
    private val javaMailSender: JavaMailSender,
    @Value("\${spring.mail.properties.registration.text}") private val text: String,
    @Value("\${spring.mail.properties.registration.subject}") private val subject: String,
    @Value("\${spring.mail.properties.registration.from}") private val from: String,
    @Value("\${hsecoffee.code.lifetime.ms}") val lifeTime: Int
) {

    @Qualifier("userRepository")
    @Autowired
    private val userRepository: UserRepository? = null

    @Autowired
    private val confirmationCodeRepository: ConfirmationCodeRepository? = null

    private fun sendCode(receiver: String, code: Int) {
        val message = SimpleMailMessage()

        message.setSubject(subject)
        message.setText(text.replace("{code}", code.toString()))
        message.setFrom(from)
        message.setTo(receiver)

        javaMailSender.send(message)
    }

    fun isValid(receiver: String, code: Int): Boolean {
        val userByCode = confirmationCodeRepository?.findByCode(code)?.user ?: return false

        if (userByCode.email == receiver && Date().time.minus(userByCode.createdDate.time) < lifeTime)
            return true

        return false
    }

    fun trySendCode(receiver: String): Boolean {
        try {
            var user = userRepository?.findByEmailEquals(email = receiver)

            if (user == null) {
                user = User(receiver, false)
                userRepository?.save(user)
            }

            // Если код существует:
            if (confirmationCodeRepository?.existsByUser(user) == true) {
                val confirmation = confirmationCodeRepository.findByUser(user)

                // Проверка на время:
                val delta = (Date.from(confirmation?.createdDate?.time?.let { Instant.now().minusMillis(it) }))

                if (delta.time > lifeTime) {
                    confirmationCodeRepository.removeConfirmationTokenByUser(user)
                    confirmationCodeRepository.save(ConfirmationCode(user))
                }
            } else {
                confirmationCodeRepository?.save(ConfirmationCode(user))
            }

            confirmationCodeRepository?.findByUser(user)?.code?.let {
                sendCode(receiver, it)
            }

            return true

        } catch (e: Exception) {
            e.printStackTrace()
        }

        return false
    }
}