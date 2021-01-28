package com.goga133.hsecoffee.repository

import com.goga133.hsecoffee.entity.Search
import com.goga133.hsecoffee.entity.User
import org.springframework.data.jpa.repository.config.EnableJpaRepositories
import org.springframework.data.repository.CrudRepository
import org.springframework.stereotype.Repository

/**
 * Интерфейс для описания операций для взаимодействия с таблицей поиска встреч.
 * @see Search
 */
@EnableJpaRepositories
@Repository("searchRepository")
interface SearchRepository : CrudRepository<Search, Long> {
    fun findSearchByFinder(finder : User) : Search?
}