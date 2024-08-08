CREATE TABLE team_members (
    id SERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    email VARCHAR(255) UNIQUE NOT NULL
);

CREATE TABLE facts (
    id SERIAL PRIMARY KEY,
    team_member_id INTEGER NOT NULL,
    fact_text TEXT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (team_member_id) REFERENCES team_members(id) ON DELETE CASCADE
);

CREATE TABLE quizzes (
    id SERIAL PRIMARY KEY,
    title VARCHAR(255) NOT NULL,
    description TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE questions (
    id SERIAL PRIMARY KEY,
    quiz_id INTEGER NOT NULL,
    question_text TEXT NOT NULL,
    related_fact_id INTEGER,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (quiz_id) REFERENCES quizzes(id) ON DELETE CASCADE,
    FOREIGN KEY (related_fact_id) REFERENCES facts(id) ON DELETE SET NULL
);

CREATE TABLE answers (
    id SERIAL PRIMARY KEY,
    question_id INTEGER NOT NULL,
    answer_text TEXT NOT NULL,
    is_correct BOOLEAN NOT NULL,
    FOREIGN KEY (question_id) REFERENCES questions(id) ON DELETE CASCADE
);

CREATE TABLE user_responses (
    id SERIAL PRIMARY KEY,
    team_member_id INTEGER NOT NULL,
    question_id INTEGER NOT NULL,
    answer_id INTEGER NOT NULL,
    response_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (team_member_id) REFERENCES team_members(id) ON DELETE CASCADE,
    FOREIGN KEY (question_id) REFERENCES questions(id) ON DELETE CASCADE,
    FOREIGN KEY (answer_id) REFERENCES answers(id) ON DELETE CASCADE
);

-- Indexes for performance
CREATE INDEX idx_team_member_email ON team_members(email);
CREATE INDEX idx_fact_team_member_id ON facts(team_member_id);
CREATE INDEX idx_question_quiz_id ON questions(quiz_id);
CREATE INDEX idx_question_related_fact_id ON questions(related_fact_id);
CREATE INDEX idx_answer_question_id ON answers(question_id);
CREATE INDEX idx_user_response_team_member_id ON user_responses(team_member_id);
CREATE INDEX idx_user_response_question_id ON user_responses(question_id);
CREATE INDEX idx_user_response_answer_id ON user_responses(answer_id);


-- Insert default quizzes
INSERT INTO quizzes (title, description) VALUES ('General Knowledge Quiz', 'A quiz to test your general knowledge.');

-- Insert questions and answers using a procedural block
DO $$ DECLARE
    quiz_id INTEGER;
BEGIN
    SELECT id INTO quiz_id FROM quizzes WHERE title = 'General Knowledge Quiz';

    -- Insert questions
    INSERT INTO questions (quiz_id, question_text, created_at) VALUES 
    (quiz_id, 'What is the capital of France?', CURRENT_TIMESTAMP),
    (quiz_id, 'What is the largest planet in our solar system?', CURRENT_TIMESTAMP),
    (quiz_id, 'Who wrote ''Romeo and Juliet''?', CURRENT_TIMESTAMP),
    (quiz_id, 'What is the chemical symbol for water?', CURRENT_TIMESTAMP),
    (quiz_id, 'What is the smallest prime number?', CURRENT_TIMESTAMP);

    -- Insert answers
    INSERT INTO answers (question_id, answer_text, is_correct) VALUES 
    (1, 'Berlin', FALSE),
    (1, 'Madrid', FALSE),
    (1, 'Paris', TRUE),
    (2, 'Earth', FALSE),
    (2, 'Jupiter', TRUE),
    (2, 'Mars', FALSE),
    (3, 'William Shakespeare', TRUE),
    (3, 'Charles Dickens', FALSE),
    (3, 'J.K. Rowling', FALSE),
    (4, 'H2O', TRUE),
    (4, 'O2', FALSE),
    (4, 'CO2', FALSE),
    (5, '1', FALSE),
    (5, '2', TRUE),
    (5, '3', FALSE);
END $$;
