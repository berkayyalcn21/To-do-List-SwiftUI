module.exports = class TodoDto {
	constructor({ id, content, isCompleted, createdAt }) {
		this.id = id;
		this.content = content;
		this.isCompleted = isCompleted;
		this.createdAt = createdAt;
	}
};
