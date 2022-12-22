var BRLogF = BRLogF || {};

BRLogF.searchBRLogsForDogID = function(dogID) {
	return fetch('/SearchBRLogsForDogID', {
		method: 'POST',
		headers: {
			"Content-Type": "application/json"
		},
		body: JSON.stringify({dog_id: dogID})
	})
	.then(response => response.json());
}

BRLogF.htmlToElement = function(html) {
	var template = document.createElement('template');
	html = html.trim();
	template.innerHTML = html;
	return template.content.firstChild;
}

BRLogF.searchBRLogByID = function(id) {
	return fetch('/SearchBRLogByID', {
		method: 'POST',
		headers: {
			"Content-Type": "application/json"
		},
		body: JSON.stringify({BRLogID: id})
	})
	.then(response => response.json())
}

BRLogF.createBRLogCard = function(brLogData) {
	for(const k in brLogData) {
		if(brLogData[k] === null || brLogData[k] === undefined) {
			brLogData[k] = '-';
		}
	}

	const brLogCardHtml = `
	<div class="card dog-card flex flex-col" style="width: 14rem;" id="brlog-card-${brLogData.ID}">
		<div class="card-body" data-bs-toggle="collapse" data-bs-target="#brlog-card-collapse-${brLogData.ID}" aria-expanded="false" style="cursor: pointer;">
			<h5 class="card-title">${brLogData.DogName}</h5>
			<p class="card-text">${brLogData.Type}</p>
			<p class="card-text">${brLogData.Date}<br />${brLogData.Time}</p>
			<span class="collapse-arrow">›</span>
		</div>
		<div class="collapse" id="brlog-card-collapse-${brLogData.ID}" style="font-size: small;">
			<ul class="list-group list-group-flush">
				<li class="list-group-item">Notes: ${brLogData.Note}</li>
			</ul>
			<div class="card-body">
				<a class="card-link" data-bs-toggle="modal" href="#updateBRLogModal" onclick="retrieveBRLogInfo(${brLogData.ID})">Edit</a>
				<a class="card-link text-danger" data-bs-toggle = "modal" href="#confirmDeletionModal" onclick="prepareDeletion(${brLogData.ID}, '${brLogData.Name}')">Delete</a>
			</div>
		</div>
	</div>`;
	
	const element = BRLogF.htmlToElement(brLogCardHtml);

	element.addEventListener('hidden.bs.collapse', function () {
		element.classList.remove("row-span-4");
	});
	
	element.addEventListener('show.bs.collapse', function () {
		element.classList.add("row-span-4");

		$(element).find(".collapse-arrow").addClass("arrow-expanded");
	});

	element.addEventListener('hide.bs.collapse', function () {
		$(element).find(".collapse-arrow").removeClass("arrow-expanded");
	});
	
	return element;
}

BRLogF.refreshBRLogCard = function(BRLogID) {
	BRLogF.searchBRLogByID(BRLogID).then(rowset => {
		const data = rowset[0];
		$(`#brlog-card-${BRLogID}`).replaceWith(BRLogF.createBRLogCard(data));
	});
}
