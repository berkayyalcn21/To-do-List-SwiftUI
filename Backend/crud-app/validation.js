const { object, string, bool } = require("yup");

const newTodoSchema = object({
	content: string().required().min(3),
});

const updateTodoSchema = object({
	content: string().required().min(3),
	isCompleted: bool().required(),
});

module.exports = { newTodoSchema, updateTodoSchema };
