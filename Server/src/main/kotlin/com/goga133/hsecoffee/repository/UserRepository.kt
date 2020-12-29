package com.goga133.hsecoffee.repository

import com.goga133.hsecoffee.entity.User
import org.springframework.data.jpa.repository.config.EnableJpaRepositories
import org.springframework.data.repository.CrudRepository
import org.springframework.stereotype.Repository

@EnableJpaRepositories
@Repository("userRepository")
interface UserRepository : CrudRepository<User, Long> {
    fun findByEmailEquals(email: String): User?
}