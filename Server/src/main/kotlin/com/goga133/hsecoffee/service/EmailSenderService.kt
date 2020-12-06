package com.goga133.hsecoffee.service

import org.springframework.beans.factory.annotation.Value
import org.springframework.mail.SimpleMailMessage
import org.springframework.mail.javamail.JavaMailSender
import org.springframework.stereotype.Service

@Service
class EmailSenderService(
        private val javaMailSender: JavaMailSender,
        @Value("\${spring.mail.properties.registration.text}") private val text: String,
        @Value("\${spring.mail.properties.registration.subject}") private val subject: String,
        @Value("\${spring.mail.properties.registration.from}") private val from : String
) {

    fun sendCode(receiver: String, code : Int) {
        val message = SimpleMailMessage()

        message.setSubject(subject)
        message.setText(text.replace("{code}", code.toString()))
        message.setFrom(from)
        message.setTo(receiver)

        javaMailSender.send(message)
    }
}