/*
import com.goga133.hsecoffee.objects.ConfirmationToken
import com.goga133.hsecoffee.objects.User
import com.goga133.hsecoffee.repository.ConfirmationTokenRepository
import com.goga133.hsecoffee.repository.UserRepository
import com.goga133.hsecoffee.service.EmailSenderService
import org.springframework.beans.factory.annotation.Autowired
import org.springframework.mail.SimpleMailMessage
import org.springframework.stereotype.Controller
import org.springframework.web.bind.annotation.RequestMapping
import org.springframework.web.bind.annotation.RequestMethod
import org.springframework.web.bind.annotation.RequestParam
import org.springframework.web.servlet.ModelAndView


@Controller
class UserAccountController {
    @Autowired
    private val userRepository: UserRepository? = null

    @Autowired
    private val confirmationTokenRepository: ConfirmationTokenRepository? = null

    @Autowired
    private val emailSenderService: EmailSenderService? = null

*/
/*
    @RequestMapping(value = ["/register"], method = [RequestMethod.POST])
    fun registerUser(modelAndView: ModelAndView, user: User): ModelAndView {
        val existingUser: User? = userRepository!!.findByEmailIdIgnoreCase(user.emailId)
        if (existingUser != null) {
            modelAndView.addObject("message", "This email already exists!")
            modelAndView.viewName = "error"
        } else {
            userRepository.save<User>(user)
            val confirmationToken = ConfirmationToken(user)
            confirmationTokenRepository!!.save(confirmationToken)
            emailSenderService.sendSimpleEmail(user.emailId!!);
            val mailMessage = SimpleMailMessage()
            mailMessage.setTo(user.emailId)
            mailMessage.setSubject("Complete Registration!")
            mailMessage.setFrom("chand312902@gmail.com")
            mailMessage.setText("To confirm your account, please click here : "
                    + "http://localhost:8082/confirm-account?token=" + confirmationToken.confirmationToken)
            emailSenderService?.sendSimpleEmail(mailMessage)
            modelAndView.addObject("emailId", user.emailId)
            modelAndView.viewName = "successfulRegisteration"
        }
        return modelAndView
    }*//*


    @RequestMapping(value = ["/confirm-account"], method = [RequestMethod.GET, RequestMethod.POST])
    fun confirmUserAccount(modelAndView: ModelAndView, @RequestParam("token") confirmationToken: String?): ModelAndView {
        val token = confirmationTokenRepository!!.findByConfirmationToken(confirmationToken)
        if (token != null) {
            val user: User? = userRepository!!.findByEmailIdIgnoreCase(token.user?.emailId)
            if (user != null) {
                user.isEnabled = true
            }
            userRepository.save(user!!)
            modelAndView.viewName = "accountVerified"
        } else {
            modelAndView.addObject("message", "The link is invalid or broken!")
            modelAndView.viewName = "error"
        }
        return modelAndView
    } // getters and setters
}*/
