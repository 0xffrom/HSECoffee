package com.goga133.hsecoffee.controllers

import com.goga133.hsecoffee.objects.ConfirmationToken
import com.goga133.hsecoffee.objects.User
import com.goga133.hsecoffee.repository.ConfirmationCodeRepository
import com.goga133.hsecoffee.repository.UserRepository
import com.goga133.hsecoffee.service.EmailSenderService
import org.springframework.beans.factory.annotation.Autowired
import org.springframework.beans.factory.annotation.Qualifier
import org.springframework.beans.factory.annotation.Value
import org.springframework.http.HttpStatus
import org.springframework.http.ResponseEntity
import org.springframework.stereotype.Controller
import org.springframework.transaction.annotation.Transactional
import org.springframework.web.bind.annotation.*
import java.util.*

@Controller
class EmailController(@Value("\${hsecoffee.code.lifetime.ms}") val lifeTime : Int){

    @Qualifier("userRepository")
    @Autowired
    private val userRepository: UserRepository? = null

    @Autowired
    private val confirmationCodeRepository: ConfirmationCodeRepository? = null

    @Autowired
    private val emailSenderService: EmailSenderService? = null

    @Transactional
    @RequestMapping(value = ["/code"], method = [RequestMethod.POST])
    fun receiver(@RequestParam(value = "email") receiver: String) : ResponseEntity<HttpStatus>{
        var user = userRepository?.findByEmailEquals(email = receiver)

        if(user == null){
            user = User(receiver, false)
            userRepository?.save(user)
        }

        // Если код существует:
        if (confirmationCodeRepository?.existsByUser(user) == true)
        {
            val confirmation = confirmationCodeRepository.findByUser(user)

            // Проверка на время:
            val delta = (Date().time - confirmation.createdDate.time)

            if (delta > lifeTime){
                confirmationCodeRepository.removeConfirmationTokenByUser(user)
                confirmationCodeRepository.save(ConfirmationToken(user))
            }
        }

        else{
            confirmationCodeRepository?.save(ConfirmationToken(user))
        }


        confirmationCodeRepository?.findByUser(user)?.code?.let {
            emailSenderService?.sendCode(receiver, it)
        }

        return ResponseEntity(HttpStatus.ACCEPTED)
    }
}