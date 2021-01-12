package com.goga133.hsecoffee.service

import com.goga133.hsecoffee.data.status.MeetStatus
import com.goga133.hsecoffee.entity.SearchParams
import com.goga133.hsecoffee.entity.User
import org.junit.Assert.*
import org.junit.jupiter.api.Assertions.assertEquals
import org.junit.jupiter.api.BeforeAll
import org.junit.jupiter.api.BeforeEach
import org.junit.jupiter.api.Test
import org.junit.jupiter.api.assertDoesNotThrow
import org.junit.runner.RunWith
import org.opentest4j.TestAbortedException
import org.springframework.beans.factory.annotation.Autowired
import org.springframework.boot.test.context.SpringBootTest
import org.springframework.test.context.junit4.SpringRunner
import java.time.Instant
import java.util.*
import java.util.concurrent.TimeUnit

@RunWith(SpringRunner::class)
@SpringBootTest
internal class MeetServiceTest {
    @Autowired
    val userService: UserService? = null

    @Autowired
    val meetService: MeetService? = null

    val user1: User = User("testUSER1")
    val user2: User = User("testUSER2")
    val user3: User = User("testUSER3")
    val user4: User = User("testUSER4")
    val user5: User = User("testUSER5")

    @BeforeEach
    fun init_users() {
        if (userService == null) {
            throw TestAbortedException()
        }

        with(userService!!){
            save(user1)
            save(user2)
            save(user3)
            save(user4)
            save(user5)
        }
    }

    @Test
    fun getMeet() {
        val meet1 = meetService?.getMeet(user1)

        assertTrue(meet1?.meetStatus == MeetStatus.NONE)
        assertTrue(meet1?.user1 == null)
        assertTrue(meet1?.user2 == null)
        TimeUnit.MILLISECONDS.sleep(100)
        assertTrue(meet1?.createdDate?.before(Date.from(Instant.now())) == true)
    }

    @Test
    fun cancelSearch() {
        meetService?.searchMeet(user5, SearchParams())

        val meet2 = meetService?.getMeet(user5)
        assertTrue(meet2?.meetStatus == MeetStatus.SEARCH)

        meetService?.cancelSearch(user5)
        assertTrue(meetService?.getMeet(user5)?.meetStatus == MeetStatus.NONE)
    }

    @Test
    fun searchMeet() {
        meetService?.apply {
            searchMeet(user4, SearchParams())
            searchMeet(user3, SearchParams())
        }

        val meet3 = meetService?.getMeet(user3)
        val meet4 = meetService?.getMeet(user4)

        assertEquals(meet3?.id, meet4?.id)

        assertEquals(meet3?.meetStatus, MeetStatus.ACTIVE)
        assertEquals(meet3?.user1?.id, user3.id)
        assertEquals(meet3?.user2?.id, user4.id)


    }

    @Test
    fun methods_non_database_user(){
        val nonDbUser = User("123")

        assertDoesNotThrow {
            meetService?.getMeet(nonDbUser)
            meetService?.getMeets(nonDbUser)
            meetService?.cancelSearch(nonDbUser)
            meetService?.searchMeet(nonDbUser, SearchParams())
        }
    }

    @Test
    fun getMeets() {
        assertTrue(meetService?.getMeets(user1)?.isEmpty() == true)
        assertTrue(meetService?.getMeets(user2)?.isEmpty() == true)
        assertTrue(meetService?.getMeets(user3)?.isEmpty() == true)
        assertTrue(meetService?.getMeets(user4)?.isEmpty() == true)
    }

}