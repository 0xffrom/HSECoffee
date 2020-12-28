package com.goga133.hsecoffee.service

import com.goga133.hsecoffee.objects.ConfirmationCode
import com.goga133.hsecoffee.repository.ConfirmationCodeRepository
import org.springframework.beans.factory.annotation.Autowired
import org.springframework.beans.factory.annotation.Value
import org.springframework.context.annotation.PropertySource
import org.springframework.mail.SimpleMailMessage
import org.springframework.mail.javamail.JavaMailSender
import org.springframework.stereotype.Service
import org.springframework.transaction.annotation.Transactional
import java.time.Instant
import java.util.*

@Service
@PropertySource("mail.properties")
class EmailService(
    private val javaMailSender: JavaMailSender,
    @Value("\${mail.text}") private val text: String,
    @Value("\${mail.subject}") private val subject: String,
    @Value("\${mail.from}") private val from: String,
    @Value("\${mail.lifetime.ms}") val lifeTime: Int
) {

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
        val confirmationCode = confirmationCodeRepository?.findByEmail(receiver) ?: return false

        if (confirmationCode.email == receiver && Instant.now().minusMillis(confirmationCode.createdDate.time)
                .toEpochMilli() < lifeTime
        )
            return true

        return false
    }

    @Transactional
    fun trySendCode(receiver: String): Boolean {
        try {
            // Если код существует:
            if (confirmationCodeRepository?.existsByEmail(receiver) == true) {
                val confirmation = confirmationCodeRepository.findByEmail(receiver)

                // Проверка на время:
                val delta = (Date.from(confirmation?.createdDate?.time?.let { Instant.now().minusMillis(it) }))

                if (delta.time > lifeTime) {
                    confirmationCodeRepository.apply {
                        removeConfirmationTokenByEmail(receiver)
                        save(ConfirmationCode(receiver))
                    }
                }

            } else {
                confirmationCodeRepository?.save(ConfirmationCode(receiver))
            }

            confirmationCodeRepository?.findByEmail(receiver)?.code?.let {
                sendCode(receiver, it)
            }

            return true

        } catch (e: Exception) {
            e.printStackTrace()
        }

        return false
    }
}