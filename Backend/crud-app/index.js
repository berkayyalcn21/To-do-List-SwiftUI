const express = require("express");
const { ValidationError } = require("yup");
const TodoDto = require("./TodoDto");
const { logRequestData, logResponseData } = require("./utils");
const { newTodoSchema, updateTodoSchema } = require("./validation");
const SERVER_PORT = process.env.PORT || 8000;

const app = express();

let TODOS = [];
let id = 0;

app.use(express.json());

app.get("/todos", logRequestData, logResponseData, (req, res) => {
	return res.status(200).json(TODOS.map((t) => ({ id: t.id, content: t.content, isCompleted: t.isCompleted })));
});

app.get("/todos/:id", logRequestData, logResponseData, (req, res) => {
	const foundTodo = TODOS.find((t) => t.id === parseInt(req.params.id));

	if (foundTodo === undefined) {
		return res.status(404).json({ error: { message: `No todo exists with the id of ${req.params.id}` } });
	}

	return res.status(200).json(foundTodo);
});

app.post("/todos", logRequestData, logResponseData, async (req, res) => {
	try {
		const validationResult = await newTodoSchema.validate(req.body);

		const newTodo = new TodoDto({
			id,
			content: validationResult.content,
			isCompleted: false,
			createdAt: new Date(),
		});
		TODOS.push(newTodo);

		id++;

		return res.status(201).json(newTodo);
	} catch (error) {
		console.log({ error });
		if (error instanceof ValidationError) {
			return res.status(400).json({ error });
		}

		return res.status(500).json({ error });
	}
});

app.put("/todos/:id", logRequestData, logResponseData, async (req, res) => {
	try {
		const validationResult = await updateTodoSchema.validate(req.body);

		const foundTodo = TODOS.find((t) => t.id === parseInt(req.params.id));

		if (foundTodo === undefined) {
			return res.status(404).json({ error: { message: `No todo exists with the id of ${req.params.id}` } });
		}

		TODOS = TODOS.map((t) =>
			t.id === foundTodo.id
				? { ...t, content: validationResult.content, isCompleted: validationResult.isCompleted }
				: t
		);

		return res.status(200).json(TODOS.find((t) => t.id === foundTodo.id));
	} catch (error) {
		console.log({ error });
		if (error instanceof ValidationError) {
			return res.status(400).json({ error });
		}

		return res.status(500).json({ error });
	}
});

app.delete("/todos/:id", logRequestData, logResponseData, async (req, res) => {
	try {
		const foundTodo = TODOS.find((t) => t.id === parseInt(req.params.id));

		if (foundTodo === undefined) {
			return res.status(404).json({ error: { message: `No todo exists with the id of ${req.params.id}` } });
		}

		TODOS = TODOS.filter((t) => t.id !== foundTodo.id);

		return res.sendStatus(204);
	} catch (error) {
		console.log({ error });
		return res.status(500).json({ error });
	}
});

app.listen(SERVER_PORT, () => {
	console.log(` > CRUD API is listening on port ${SERVER_PORT}`);
});
