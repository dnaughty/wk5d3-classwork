PRAGMA foreign_keys = ON;

DROP TABLE if exists users;

CREATE TABLE users (
  id INTEGER PRIMARY KEY,
  fname TEXT NOT NULL,
  lname TEXT NOT NULL
  );

DROP TABLE if exists questions;
CREATE TABLE questions (
  id INTEGER PRIMARY KEY,
  title  TEXT,
  body TEXT,
  user_id INTEGER NOT NULL,

  FOREIGN KEY (user_id) REFERENCES users(id)
  );

DROP TABLE if exists question_follows;
  CREATE TABLE question_follows (
    id INTEGER PRIMARY KEY,
    user_id INTEGER NOT NULL, 
    questioner INTEGER NOT NULL,

    FOREIGN KEY (user_id) REFERENCES users(id),
    FOREIGN KEY (questioner) REFERENCES questions(id) 

  );

DROP TABLE if exists replies;
  CREATE TABLE replies (
    id INTEGER PRIMARY KEY,
    subject_question INTEGER NOT NULL,
    questioner INTEGER NOT NULL,
    body TEXT NOT NULL,
    parent_reply INTEGER,

    FOREIGN KEY (subject_question) REFERENCES questions(id),
    FOREIGN KEY (questioner) REFERENCES users(id), 
    FOREIGN KEY (parent_reply) REFERENCES replies(id)
    );

DROP TABLE if exists question_likes;
  CREATE TABLE question_likes (
    id INTEGER PRIMARY KEY,
    user_id INTEGER NOT NULL,
    question_id INTEGER NOT NULL,
    FOREIGN KEY (question_id) REFERENCES questions(id),
    FOREIGN KEY (user_id) REFERENCES users(id)
  );


INSERT INTO 
  users (fname, lname)
VALUES
  ('Nicole', 'Samanich');

INSERT INTO 
  questions (title, body, user_id)
VALUES
  ('Tan?', 'How did Denis get so tan?',
  (SELECT id FROM users WHERE fname = 'Nicole'));

INSERT INTO 
  replies (subject_question, questioner, body, parent_reply)
VALUES
  ((SELECT id FROM questions WHERE title = 'Tan?'),
  (SELECT id FROM users WHERE fname = 'Nicole'),
  (SELECT body from questions WHERE body = 'How did Denis get so tan?'),
  (SELECT id FROM replies WHERE questioner = (SELECT id FROM users WHERE fname = 'Nicole'))
  );

INSERT INTO 
  question_likes(user_id, question_id)
VALUES
  ((SELECT id FROM users WHERE fname = 'Nicole'), 
  (SELECT id FROM questions WHERE title = 'Tan?'));

  INSERT INTO 
    question_follows(user_id, questioner)
  VALUES
    ((SELECT id FROM users WHERE fname = 'Nicole'),
    (SELECT id FROM questions WHERE title = 'Tan?'));

  









