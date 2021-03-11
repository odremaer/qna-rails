users = User.create!([
  {email: "john@gmail.com", password: '123123', password_confirmation: '123123'},
  {email: "paul@gmail.com", password: '123123', password_confirmation: '123123'},
  {email: 'admin@admin.ru', password: '123123', password_confirmation: '123123'}
])

questions = Question.create!([
  {title: 'Появление Ruby', body: "В какому году появился Ruby? ", user: users[0]},
  {title: 'Расширение файлов у Ruby', body: "Какое расширение у файлов Ruby?", user: users[1]},
  {title: 'Метод #unshift', body: "Что делает #unshift с массивом?", user: users[2]}
  ])

  Answer.create!([
    {body: "2000", question: questions[0]},
    {body: "1995", question: questions[0]},
    {body: "1990", question: questions[0]},

    {body: "rb", question: questions[1]},
    {body: "exe", question: questions[1]},
    {body: "c", question: questions[1]},

    {body: "Добавляет элементы в начало массива", question: questions[2]},
    {body: "Добавляет элементы в конец массива", question: questions[2]},
    {body: "Очищает массив", question: questions[2]}
  ])
