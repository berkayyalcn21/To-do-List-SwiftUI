const logRequestData = (req, res, next) => {
	console.log(`\n > ${req.method} '${req.url}' at ${new Date().toLocaleString()}`);

	return next();
};

const logResponseData = (req, res, next) => {
	const oldWrite = res.write;
	const oldEnd = res.end;

	const chunks = [];

	res.write = (chunk, ...args) => {
		chunks.push(chunk);
		return oldWrite.apply(res, [chunk, ...args]);
	};

	res.end = (chunk, ...args) => {
		if (chunk) {
			chunks.push(chunk);
		}
		const body = Buffer.concat(chunks).toString("utf8");
		console.log(
			` > RESPONSE to ${req.method} '${req.url}' at ${new Date().toLocaleString()}\n   ${JSON.stringify(
				body
			)}\n`
		);
		return oldEnd.apply(res, [chunk, ...args]);
	};

	next();
};

module.exports = { logRequestData, logResponseData };
