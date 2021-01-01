package com.goga133.hsecoffee.service

import com.goga133.hsecoffee.data.status.MeetStatus
import com.goga133.hsecoffee.entity.SearchParams
import com.goga133.hsecoffee.entity.User
import org.junit.Assert.assertEquals
import org.junit.Assert.assertTrue
import org.junit.Test
import org.junit.jupiter.api.BeforeAll
import org.junit.jupiter.api.assertDoesNotThrow
import org.junit.runner.RunWith
import org.opentest4j.TestAbortedException
import org.springframework.beans.factory.annotation.Autowired
import org.springframework.boot.test.context.SpringBootTest
import org.springframework.test.context.junit4.SpringRunner
import java.util.*

@RunWith(SpringRunner::class)
@SpringBootTest
class MeetServiceTest {
    @Autowired
    val userService: UserService? = null

    @Autowired
    val meetService: MeetService? = null

    val user1: User = User("testUSER1")
    val user2: User = User("testUSER2")
    val user3: User = User("testUSER3")
    val user4: User = User("testUSER4")

    @BeforeAll
    fun init_users() {
        TODO("ПРОТЕСТИРОВАТЬ")

        if (userService == null) {
            throw TestAbortedException()
        }

        userService?.save(user1)
        userService?.save(user2)
        userService?.save(user3)
        userService?.save(user4)
    }

    @Test
    fun getMeet() {
        val meet1 = meetService?.getMeet(user1)

        assertTrue(meet1?.meetStatus == MeetStatus.NONE)
        assertTrue(meet1?.user1 == user1)
        assertTrue(meet1?.user2 == null)
        assertTrue(meet1?.createdDate?.before(Date()) == true)

        val meet2 = meetService?.getMeet(user2)
        assertTrue(meet2?.meetStatus == MeetStatus.SEARCH)
        assertTrue(meet2?.user1 == user2)
        assertTrue(meet2?.user2 == null)
    }

    @Test
    fun cancelSearch() {
        meetService?.searchMeet(user2, SearchParams())

        val meet2 = meetService?.getMeet(user2)
        assertTrue(meet2?.meetStatus == MeetStatus.SEARCH)

        meetService?.cancelSearch(user2)
        assertTrue(meetService?.getMeet(user2)?.meetStatus == MeetStatus.NONE)
    }

    @Test
    fun searchMeet() {
        meetService?.apply {
            searchMeet(user4, SearchParams())
            searchMeet(user3, SearchParams())
        }

        val meet3 = meetService?.getMeet(user3)
        val meet4 = meetService?.getMeet(user4)

        assertEquals(meet3, meet4)

        assertTrue(meet3?.meetStatus == MeetStatus.ACTIVE)
        assertTrue(meet3?.user1 == user4)
        assertTrue(meet3?.user2 == user3)
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