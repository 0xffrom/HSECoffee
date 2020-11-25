package com.goga133.hsecoffee.controllers

import com.goga133.hsecoffee.repository.ConfirmationCodeRepository
import com.goga133.hsecoffee.repository.UserRepository
import com.goga133.hsecoffee.service.EmailSenderService
import org.springframework.beans.factory.annotation.Autowired
import org.springframework.beans.factory.annotation.Qualifier
import org.springframework.http.HttpStatus
import org.springframework.http.ResponseEntity
import org.springframework.stereotype.Controller
import org.springframework.web.bind.annotation.*
import java.util.*

@Controller
public class EmailController(){

    @Qualifier("userRepository")
    @Autowired
    private val userRepository: UserRepository? = null

    @Autowired
    private val confirmationCodeRepository: ConfirmationCodeRepository? = null

    @Autowired
    private val emailSenderService: EmailSenderService? = null

    @RequestMapping(value = ["/email"], method = [RequestMethod.POST])
    fun receiver(@RequestParam(value = "receiver") receiver: String) : ResponseEntity<HttpStatus>{
        // Если код существует:
        if (confirmationCodeRepository?.existsByUserEmail(receiver) == true)
        {
            val confirmation = confirmationCodeRepository.findByUserEmail(receiver)
            // Проверка на время:
            val delta = (confirmation.createdDate.time - Date().time) / 1000 / 60

            if (delta > 5){
                confirmation.
                confirmationCodeRepository.removeConfirmationTokenByUser()
            }
        }
        confirmationCodeRepository.f

        emailSenderService?.sendCode(receiver, 111111);

        return ResponseEntity(HttpStatus.ACCEPTED)
    }
}