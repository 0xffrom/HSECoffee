package com.goga133.hsecoffee.service

import com.goga133.hsecoffee.repository.ImageStorageRepository
import org.junit.platform.commons.logging.LoggerFactory
import org.springframework.core.io.Resource
import org.springframework.core.io.UrlResource
import org.springframework.stereotype.Service
import org.springframework.util.FileSystemUtils
import org.springframework.web.multipart.MultipartFile
import java.nio.file.Files
import java.nio.file.Path
import java.nio.file.Paths
import java.util.stream.Stream

@Service
class ImageStorageService : ImageStorageRepository {
    private val rootLocation: Path = Paths.get("uploads")

    override fun store(file: MultipartFile) {
        Files.copy(file.inputStream, this.rootLocation.resolve(file.originalFilename!!))
    }

    override fun loadFile(filename: String): Resource {
        val file = rootLocation.resolve(filename)
        val resource = UrlResource(file.toUri())

        if (resource.exists() || resource.isReadable) {
            return resource
        } else {
            throw RuntimeException("Ошибка при загрузке фотографии")
        }
    }

    override fun deleteAll() {
        FileSystemUtils.deleteRecursively(rootLocation.toFile())
    }

    override fun init() {
        Files.createDirectory(rootLocation)
    }

    override fun loadFiles(): Stream<Path> {
        return Files.walk(this.rootLocation, 1)
            .filter { path -> path != this.rootLocation }
            .map(this.rootLocation::relativize)
    }
}