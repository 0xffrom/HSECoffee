package com.goga133.hsecoffee.service

import com.goga133.hsecoffee.objects.User
import com.goga133.hsecoffee.repository.UserRepository
import org.springframework.beans.factory.annotation.Autowired
import org.springframework.beans.factory.annotation.Qualifier
import org.springframework.stereotype.Service

@Service
class UserService {
    @Qualifier("userRepository")
    @Autowired
    private val userRepository: UserRepository? = null

    fun getUserByEmailOrCreate(email: String): User? {
        var user = getUserByEmail(email)

        if (user == null) {
            user = createUserByEmail(email)
        }

        return user
    }

    fun getUserByEmail(email: String): User? {
        return userRepository?.findByEmailEquals(email = email);
    }

    fun createUserByEmail(email: String): User? {
        val user = User(email)
        try {
            userRepository?.save(user)
            return user
        } catch (e: Exception) {
            e.printStackTrace()
        }

        return null;
    }

    fun save(user : User){
        userRepository?.save(user)
    }
}