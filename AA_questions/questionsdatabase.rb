require 'sqlite3'
require 'Singleton'
class QuestionsDatabase < SQLite3::Database
  include Singleton

  def initialize
    super('questions.db')
    self.type_translation = true
    self.results_as_hash = true
  end

end


class Question

  def self.find_by_id(id)
  question = QuestionsDatabase.instance.execute(<<-SQL,id)
    SELECT 
      *
    FROM
      questions
    WHERE
      id = ? 
  SQL
  return nil unless question.length > 0
  Question.new(*question)
  end

  attr_accessor :id, :title, :body
  def initialize(questions_hash)
    @id = questions_hash["id"]
    @title = questions_hash["title"]
    @body = questions_hash["body"]
    @user_id = questions_hash["user_id"]
  end

  def self.find_by_author_id(author_id)
    question = QuestionsDatabase.instance.execute(<<-SQL,author_id)
    SELECT 
    *
    FROM 
    questions
    WHERE 
    user_id = ?
    SQL
      return nil unless question.length > 0
        Question.new(*question)
  end
  

end


class Users

  def self.find_by_id(id)
    user  = QuestionsDatabase.instance.execute(<<-SQL,id)
      SELECT
      *
      FROM
      users 
      WHERE 
      id = ?
      SQL
  return nil unless user.length > 0

  Users.new(*user)
end




  attr_accessor :id, :fname, :lname
  def initialize(users_hash)
    @id = users_hash['id']
    @fname = users_hash['fname']
    @lname = users_hash['lname']
  end


  def self.find_by_name(fname,lname)
    user  = QuestionsDatabase.instance.execute(<<-SQL,fname,lname)
      SELECT
      *
      FROM
      users 
      WHERE 
      fname = ? AND lname = ?
      SQL
  return nil unless user.length > 0

  Users.new(*user)

  end

  def authored_questions
    current_user = self.id
    Question.find_by_author_id(current_user)
  end

  def authored_replies
    current_user = self.id
    Replies.find_by_user_id(current_user)
  end

end





class QuestionFollows
  def self.find_by_id(id)
    question_follow = QuestionsDatabase.instance.execute(<<-SQL,id)
    SELECT 
    *
    FROM 
      question_follows
    WHERE 
      id = ?
    SQL

    return nil unless question_follow.length > 0

    QuestionFollows.new(*question_follow)
  end

    attr_accessor :id, :user_id, :questioner
    def initialize(question_follows)
      @id = question_follows["id"]
      @user_id = question_follows["user_id"]
      @questioner = question_follows["questioner"]
    end
  
end

class Replies 

def self.find_by_id(id)

  replies = QuestionsDatabase.instance.execute(<<-SQL,id)
  SELECT
    *
  FROM 
    replies
  WHERE 
    id = ?
  SQL

  return nil unless replies.length > 0
  Replies.new(*replies)
end

  attr_accessor :id, :subject_question, :questioners, :body, :parent_reply

  def initialize(replies)
    @id = replies["id"]
    @subject_question = replies["subject_question"]
    @questioner = replies["questioner"]
    @body = replies["body"]
    @parent_reply = replies["parent_reply"]
  end

  def self.find_by_user_id(user_id)
    replies = QuestionsDatabase.instance.execute(<<-SQL,user_id)
      SELECT
      *
      FROM 
      replies
      WHERE 
      questioner = ?
      SQL

    return nil unless replies.length > 0
    Replies.new(*replies)
  end

  def self.find_by_question_id(question_id)
    replies = QuestionsDatabase.instance.execute(<<-SQL,question_id)
      SELECT
      *
      FROM 
      replies
      WHERE question_id = ?
      SQL

    return nil unless replies.length > 0
    Replies.new(*replies)
  end

end
class QuestionLikes

    def self.find_by_id(id)
      question_like =  QuestionsDatabase.instance.execute(<<-SQL,id)
      SELECT 
      *
      FROM 
        question_likes
      WHERE
        id = ?
      SQL

      return nil unless question_like.length > 0
      QuestionLikes.new(*question_like)
    end

    attr_accessor :id, :user_id, :question_id

    def initialize(qlhash)
      @id = qlhash["id"]
      @user_id = qlhash["user_id"]
      @question_id = qlhash["question_id"]
    end







end








# test = {"title" => "What is", "body" => "the meaning of life?" }