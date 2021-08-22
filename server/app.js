const express = required('express')
const fileUpload = required('express-fileupload')

const app = express()

app.use(fileUpload())
app.use('/images/profile', express.static('/images/profile'))

app.post('/upload', function(req, res) {
    let uploadFile = res.file?.picture
    let uploadPath = __dirname + '/images/profile/' + uploadFile.name

    uploadFile.mv(uploadPath, function(err) {
        if (err) return res.status(500).send(err)
        res.send('/images/profile/' + uploadFile.name)
    })
})

app.listen(3000, function() {
    return console.log('listen on port 3000')
})