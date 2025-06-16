<script lang="ts">
	const dateStart = $state(formatDate(addDays(-30)));
	const dateEnd = $state(formatDate(addDays(30)));

	function addDays(numDays: number) {
		const date = new Date();
		date.setTime(date.getTime() + numDays * (24 * 60 * 60 * 1000));
		return date;
	}

	function formatDate(date: Date) {
		return `${date.getUTCFullYear()}-${padTwoDigits(date.getUTCMonth())}-${padTwoDigits(date.getDay())}`;
	}

	function padTwoDigits(s: number) {
		if (s < 10) {
			return `0${s}`;
		}
		return s;
	}

	type ScheduleRow = {
		home_team_name: string;
		home_team_id: string;
		away_team_name: string;
		away_team_id: string;
		start_date: string;
		match_status: string;
		match_id: string;
		planned_kickoff_time: string;
	};

	let scheduleRows = $state([] as ScheduleRow[]);
	$effect(() => {
		(async () => {
			const baseUrl = `https://stats-api.mlssoccer.com/matches/seasons/MLS-SEA-0001K9?match_date[gte]=${dateStart}&match_date[lte]=${dateEnd}&team_id=MLS-CLU-000008&per_page=100&sort=planned_kickoff_time:asc,home_team_name:asc`;
			const res = await fetch(baseUrl);
			const jsonResults = await res.json();
			scheduleRows = jsonResults.schedule;
		})();
	});
</script>

<div class="mx-auto flex max-w-lg flex-col gap-2 py-4">
	{#each scheduleRows as row (row.match_id)}
		{@const date = new Date(row.planned_kickoff_time)}
		<div class="flex flex-col items-center gap-2 rounded-lg border-1 border-gray-400 p-2">
			<div class="grid grid-cols-[1fr_auto_1fr] gap-2">
				<span class="w-full text-right">{row.home_team_name}</span>
				<span>vs.</span>
				<span class="w-full">{row.away_team_name}</span>
			</div>
			<span class="text-gray-500">
				{row.match_status}
			</span>
			<span class="text-gray-500">
				{date.toLocaleString()}
			</span>
		</div>
	{/each}
</div>
