package com.goga133.hsecoffee.repository

import com.goga133.hsecoffee.objects.Search
import com.goga133.hsecoffee.objects.SearchParams
import com.goga133.hsecoffee.objects.User
import org.springframework.data.jpa.repository.config.EnableJpaRepositories
import org.springframework.data.repository.CrudRepository
import org.springframework.stereotype.Repository

@EnableJpaRepositories
@Repository("searchRepository")
interface SearchRepository : CrudRepository<Search, Long> {
    fun findSearchByFinder(finder : User) : Search?
}