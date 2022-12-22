var ShiftF = ShiftF || {};

ShiftF.fetchAllShift = function() {
	return fetch('/FetchAllShift', {
		method: 'POST', 
	}).then(response => response.json());
}

ShiftF.searchShiftByID = function(shiftID) {
	return fetch('/SearchShiftByID', {
		method: 'POST',
		headers: {
			"Content-Type": "application/json"
		},
		body: JSON.stringify({shift_id: shiftID})
	})
	.then(response => response.json())
}

ShiftF.getOnDuty = function(ID) {
	return fetch('/GetVolunteersOnDuty', {
		method: "POST",
		headers: {
			"Content-Type": "application/json"
		},
		body: JSON.stringify({ShiftID : ID})
	}).then(response => response.json());
}


ShiftF.createShiftCard = function(shiftData) {
    
	for(const k in shiftData) {
		if(shiftData[k] === null || shiftData[k] === undefined) {
			shiftData[k] = '-';
		}
	}

	const shiftCardHtml = `
		<div class="card shift-card flex flex-col" style="width: 14rem;" id="shift-card-${shiftData.ID}">
			<div class="card-body" data-bs-toggle="collapse" data-bs-target="#shift-card-collapse-${shiftData.ID}" aria-expanded="false" style="cursor: pointer;">
				<h5 class="card-title">${shiftData.Date}</h5>
				<p class="card-text">${shiftData.StartTime}</p>
				<span class="collapse-arrow">›</span>
			</div>
			<div class="collapse" id="shift-card-collapse-${shiftData.ID}" style="font-size: small;">
				<ul class="list-group list-group-flush">
					<li class="list-group-item">Span: ${shiftData.Span}</li>
					<li class="list-group-item">TODO: ${shiftData.TODO}</li>
					<li class="list-group-item">Note: ${shiftData.Note}</li>
				</ul>
				<div class="card-body">
					<div>
						<a class="card-link" data-bs-toggle="modal" href="#updateShiftModal" onclick="retrieveShiftInfo(${shiftData.ID})">Edit</a>
						<a class="card-link text-danger" data-bs-toggle = "modal" href="#confirmDeletionModal" onclick="prepareDeletion(${shiftData.ID})">Delete</a>
					</div>
					<div class="mt-2">
						<a class="card-link mt-2" data-bs-toggle="modal" href="#showOnDutyModal" onclick="prepareVolunteersOnDuty(${shiftData.ID})">Show Volunteers On Duty</a>
					</div>
				</div>
			</div>
		</div>`;
	
	const element = ShiftF.htmlToElement(shiftCardHtml);

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

ShiftF.refreshShiftCard = function(shiftId) {
	ShiftF.searchShiftByID(shiftId).then(rowset => {
		const shiftData = rowset[0];
		$(`#shift-card-${shiftId}`).replaceWith(ShiftF.createShiftCard(shiftData));
	});
}

ShiftF.createOnDutyItem = function(vData) {

	const OnDutyItemHtml = `
		<div id="OnDuty-${vData.ID}" target-od=${vData.ID} class="mb-3 OnDutyItem row">
			<div class="col-sm">
				<h6>${vData.VolunteerName}</h6>
				<div>
					<input type="checkbox" class="is_leader" id="is-leader-${vData.ID}"></input>
					<label for="is-leader-${vData.ID}" style="font-size: 14px" >Is Shift Leader</label>
				</div>
				<script>
					if (${vData.isShiftLeader}) {
						$('#OnDuty-${vData.ID} div input').attr('checked', true);
					}
				</script>
			</div>
			<div class="col-sm" style="display: flex;">
				<button type="button" class="btn btn-secondary btn-sm OnDutyItemButton" onclick="deleteOnDuty(${vData.ID})">Remove</button>
			</div>
		</div>
	`

	return ShiftF.htmlToElement(OnDutyItemHtml);
}

ShiftF.htmlToElement = function(html) {
	var template = document.createElement('template');
	html = html.trim();
	template.innerHTML = html;
	return template.content.firstChild;
}