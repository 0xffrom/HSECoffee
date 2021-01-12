package com.goga133.hsecoffee.service

import com.goga133.hsecoffee.entity.ConfirmationCode
import com.goga133.hsecoffee.repository.ConfirmationCodeRepository
import org.slf4j.Logger
import org.slf4j.LoggerFactory
import org.springframework.beans.factory.annotation.Autowired
import org.springframework.beans.factory.annotation.Value
import org.springframework.mail.SimpleMailMessage
import org.springframework.mail.javamail.JavaMailSender
import org.springframework.stereotype.Service
import org.springframework.transaction.annotation.Transactional
import java.time.Instant
import java.util.*

/**
 * Сервис для работы с Email, в частности с протоколом SMTP для отправки EMAIL-сообщений.
 *
 * @param text - Текст письма.
 * @param subject - Тема письма.
 * @param from - Email-адресс отправителя.
 * @param lifeTime - Время действия кода в милисекундах.
 * @param domains - Разрешенные домены для почт получателя. Разделяются ';'.
 */
@Service
class EmailService(
    private val javaMailSender: JavaMailSender,
    @Value("\${mail.text}") private val text: String,
    @Value("\${mail.subject}") private val subject: String,
    @Value("\${mail.from}") private val from: String,
    @Value("\${mail.lifetime.ms}") private var lifeTime: Int,
    @Value("\${mail.domains}") private val domains: String
) {
    companion object {
        /**
         * Минимальная длина логика у EMAIL адреса. Логином считается первая часть, разделённая @.
         * Например: abcd@edu.hse.ru => логин abcd.
         */
        const val MIN_LENGTH_LOGIN = 3
    }

    /**
     * Логгер.
     */
    private val logger: Logger = LoggerFactory.getLogger(EmailService::class.java)

    /**
     * Репозиторий для кодов подтверждения.
     */
    @Autowired
    private val confirmationCodeRepository: ConfirmationCodeRepository? = null

    /**
     * Проверка на валидность кода относительно Email-адреса.
     * @param receiver - email-адрес.
     * @param code - код, отправленный на email-адрес.
     * @return true - если код верный, false - если код неверный или произошла ошибка.
     */
    fun isValidCode(receiver: String, code: Int): Boolean {
        val confirmationCode = confirmationCodeRepository?.findByEmail(receiver) ?: return false

        if (confirmationCode.code == code) {
            if (Instant.now().minusMillis(confirmationCode.createdDate.time)
                    .toEpochMilli() <= lifeTime
            ) {
                logger.debug("Код $code для $receiver корректный.")
                return true
            }

            logger.debug("Код $code для $receiver недействителен.")
            return false
        }

        logger.debug("Код $code для $receiver некорректный.")
        return false
    }

    /**
     * Проверка на валидность Email-адреса.
     * Валидным Email-адресом считается такой, который содержит больше [MIN_LENGTH_LOGIN] символов.
     * @see MIN_LENGTH_LOGIN
     * @param email - email-адрес, проверяемый на корректность.
     * @return true - если адрес корректный, иначе - false.
     */
    fun isValidMail(email: String?): Boolean {
        if (email.isNullOrEmpty())
            return false

        domains.split(";").forEach { domain ->
            if (email.endsWith(domain) && email.length - domain.length > MIN_LENGTH_LOGIN) {
                logger.debug("$email корректный.")
                return true
            }
        }

        logger.debug("$email некорректный.")
        return false
    }

    /**
     * Метод для генерации, создания и отправки кода на Email-адрес.
     * @param receiver - email-адрес, на который нужно отправить код.
     * @return True - если отправка успешна, False - иначе.
     */
    @Transactional
    fun trySendCode(receiver: String): Boolean {
        try {
            // Если код существует:
            if (confirmationCodeRepository?.existsByEmail(receiver) == true) {
                val confirmation = confirmationCodeRepository.findByEmail(receiver)
                logger.debug("Для email = $receiver был найден $confirmation")

                // Проверка на время:
                val delta = (Date.from(confirmation?.createdDate?.time?.let { Instant.now().minusMillis(it) }))

                if (delta.time > lifeTime) {
                    logger.debug("Для email = $receiver срок действия предыщего кода вышел, будет сгенерирован новый.")
                    confirmationCodeRepository.apply {
                        removeConfirmationTokenByEmail(receiver)
                        save(ConfirmationCode(receiver))
                    }
                }
            } else {
                with(ConfirmationCode(receiver)) {
                    logger.debug("Для email = $receiver был сгененирован $this")
                    confirmationCodeRepository?.save(this)
                }
            }

            confirmationCodeRepository?.findByEmail(receiver)?.code?.let {
                sendCode(receiver, it)
            }

            return true

        } catch (e: Exception) {
            logger.error("Произошла ошибка при отправке кода подтверждения", e)
            return false
        }
    }

    /**
     * Ручное выставление времени. Используется для Unit-тестов.
     * @param lifeTime - время действия кода в милисекундах.
     */
    fun setLifeTime(lifeTime: Int) {
        this.lifeTime = lifeTime
    }

    /**
     * Метод для отправки целочисленного кода на Email-адрес.
     * @param receiver - email - получатель кода.
     * @param code - целочисленный код.
     */
    private fun sendCode(receiver: String, code: Int) {
        val message = SimpleMailMessage()

        message.apply {
            setSubject(subject!!)
            setText(text!!.replace("{code}", code.toString()))
            setFrom(from!!)
            setTo(receiver)
            javaMailSender.send(this)
        }

        logger.debug("На почту $receiver был отправлен следующий код подтверждения: $code")
    }
}