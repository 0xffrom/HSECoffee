package com.goga133.hsecoffee.service

import com.goga133.hsecoffee.objects.ConfirmationCode
import com.goga133.hsecoffee.repository.ConfirmationCodeRepository
import org.springframework.beans.factory.annotation.Autowired
import org.springframework.beans.factory.annotation.Value
import org.springframework.mail.SimpleMailMessage
import org.springframework.mail.javamail.JavaMailSender
import org.springframework.stereotype.Service
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

    @Autowired
    private val confirmationCodeRepository: ConfirmationCodeRepository? = null

    @Autowired
    private val userService: UserService? = null

    private fun sendCode(receiver: String, code: Int) {
        val message = SimpleMailMessage()

        message.setSubject(subject)
        message.setText(text.replace("{code}", code.toString()))
        message.setFrom(from)
        message.setTo(receiver)

        javaMailSender.send(message)
    }

    fun isValid(receiver: String, code: Int): Boolean {
        val userByCode = confirmationCodeRepository?.findByCode(code) ?: return false

        if (userByCode.user?.email == receiver && Instant.now().minusMillis(userByCode.createdDate.time).toEpochMilli() < lifeTime)
            return true

        return false
    }

    fun trySendCode(receiver: String): Boolean {
        try {
            var user = userService?.getUserByEmail(receiver);

            if (user == null) {
                user = userService?.createUserByEmail(receiver) ?: return false
            }

            // Если код существует:
            if (confirmationCodeRepository?.existsByUser(user) == true) {
                val confirmation = confirmationCodeRepository.findByUser(user)

                // Проверка на время:
                val delta = (Date.from(confirmation?.createdDate?.time?.let { Instant.now().minusMillis(it) }))

                if (delta.time > lifeTime) {
                    confirmationCodeRepository.apply {
                        removeConfirmationTokenByUser(user)
                        save(ConfirmationCode(user))
                    }
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