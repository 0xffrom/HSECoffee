package com.goga133.hsecoffee.service

import com.goga133.hsecoffee.entity.User
import com.goga133.hsecoffee.repository.UserRepository
import org.springframework.beans.factory.annotation.Autowired
import org.springframework.beans.factory.annotation.Qualifier
import org.springframework.beans.factory.annotation.Value
import org.springframework.context.annotation.PropertySource
import org.springframework.stereotype.Service
import java.net.InetAddress

@Service
class UserService(
    @Value("\${storage.folder}")
    private val folder: String,
    @Value("\${server.address}")
    private val serverAddress : InetAddress,
) {
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
        return userRepository?.findByEmail(email = email);
    }

    fun createUserByEmail(email: String): User? {
        val user = User(email)

        userRepository?.save(user)
        return user
    }

    fun changeFolderAndSave(user: User) {
        with(user){
            photoUri = "${folder.replace("{ip}", serverAddress.hostAddress)}${user.email}"
            save(this)
        }

    }

    fun save(user: User) {
        userRepository?.save(user)
    }
}