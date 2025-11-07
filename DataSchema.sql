CREATE TABLE users (
    user_id INT AUTO_INCREMENT,
    username VARCHAR(50) NOT NULL UNIQUE,
    email VARCHAR(100) NOT NULL UNIQUE,
    password_hash VARCHAR(255) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT pk_users PRIMARY KEY (user_id),
    CONSTRAINT chk_users_email
    CHECK (
        email REGEXP '^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\\.[a-zA-Z]{2,}$'
    ),
    CONSTRAINT chk_users_username
    CHECK (username REGEXP '^[a-zA-Z0-9_]{3,20}$')
);

CREATE TABLE therapists (
    therapist_id INT AUTO_INCREMENT,
    full_name VARCHAR(100) NOT NULL,
    specialization VARCHAR(100),
    contact_email VARCHAR(100) NOT NULL UNIQUE,

    CONSTRAINT pk_therapists PRIMARY KEY (therapist_id),
    CONSTRAINT chk_therapists_email
    CHECK (
        contact_email REGEXP '^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\\.[a-zA-Z]{2,}$'
    )
);

CREATE TABLE literary_works (
    work_id INT AUTO_INCREMENT,
    user_id INT NOT NULL,
    title VARCHAR(255) NOT NULL,
    content TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT pk_literary_works PRIMARY KEY (work_id),
    CONSTRAINT fk_literary_works_user
    FOREIGN KEY (user_id)
    REFERENCES users (user_id)
    ON DELETE CASCADE
);

CREATE TABLE housing_searches (
    search_id INT AUTO_INCREMENT,
    user_id INT NOT NULL,
    comfort_params JSON,
    safety_params JSON,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT pk_housing_searches PRIMARY KEY (search_id),
    CONSTRAINT fk_housing_searches_user
    FOREIGN KEY (user_id)
    REFERENCES users (user_id)
    ON DELETE CASCADE
);

CREATE TABLE therapy_requests (
    request_id INT AUTO_INCREMENT,
    user_id INT NOT NULL,
    therapist_id INT NOT NULL,
    request_details TEXT NOT NULL,
    request_status VARCHAR(20) DEFAULT 'pending',
    sent_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT pk_therapy_requests PRIMARY KEY (request_id),
    CONSTRAINT fk_therapy_requests_user
    FOREIGN KEY (user_id)
    REFERENCES users (user_id)
    ON DELETE CASCADE,
    CONSTRAINT fk_therapy_requests_therapist
    FOREIGN KEY (therapist_id)
    REFERENCES therapists (therapist_id),
    CONSTRAINT chk_therapy_requests_status
    CHECK (request_status IN ('pending', 'answered', 'closed'))
);

CREATE TABLE therapy_responses (
    response_id INT AUTO_INCREMENT,
    request_id INT NOT NULL,
    therapist_id INT NOT NULL,
    response_details TEXT NOT NULL,
    sent_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT pk_therapy_responses PRIMARY KEY (response_id),
    CONSTRAINT fk_therapy_responses_request
    FOREIGN KEY (request_id)
    REFERENCES therapy_requests (request_id)
    ON DELETE CASCADE,
    CONSTRAINT fk_therapy_responses_therapist
    FOREIGN KEY (therapist_id)
    REFERENCES therapists (therapist_id)
);
