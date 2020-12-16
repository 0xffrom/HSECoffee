package com.goga133.hsecoffee.repository

import com.goga133.hsecoffee.objects.RefreshToken
import com.goga133.hsecoffee.objects.User
import org.springframework.data.jpa.repository.config.EnableJpaRepositories
import org.springframework.data.repository.CrudRepository
import org.springframework.stereotype.Repository

@EnableJpaRepositories
@Repository("refreshToken")
interface RefreshTokenRepository: CrudRepository<RefreshToken, Long> {
    fun findRefreshTokenByUser(user : User) : RefreshToken?
}