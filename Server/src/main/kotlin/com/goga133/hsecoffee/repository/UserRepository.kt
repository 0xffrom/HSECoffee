package com.goga133.hsecoffee.repository

import com.goga133.hsecoffee.objects.User
import org.springframework.data.repository.CrudRepository
import org.springframework.stereotype.Repository


@Repository("userRepository")
interface UserRepository : CrudRepository<User, String> {
    fun findByEmailEquals(email: String): User
}