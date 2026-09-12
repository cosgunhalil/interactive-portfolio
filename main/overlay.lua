--- DOM overlay above the game canvas, driven through html5.run().
-- Videos use the real YouTube player. Links show a card with an "open in new tab" anchor,
-- because most sites refuse to be iframed. Text shows a card.
-- Closes on backdrop click, Escape, or the close button; JS sets window.__tw_overlay_open
-- to false and Lua polls it in update() to restore input.
-- Outside HTML5 (the editor) the overlay is simulated so the input gate can still be tested.
local M = {}

local is_open = false

-- TW_DATA is replaced with a JSON object { type, payload, title }.
local JS = [==[
(function () {
	if (document.getElementById('tw-overlay')) { return; }
	var d = TW_DATA;
	window.__tw_overlay_open = true;

	var wrap = document.createElement('div');
	wrap.id = 'tw-overlay';
	wrap.style.cssText = 'position:fixed;inset:0;background:rgba(0,0,0,.88);display:flex;' +
		'align-items:center;justify-content:center;z-index:9999;';

	var panel;
	if (d.type === 'video') {
		panel = document.createElement('iframe');
		panel.src = 'https://www.youtube-nocookie.com/embed/' + encodeURIComponent(d.payload) + '?autoplay=1&rel=0';
		panel.style.cssText = 'width:90%;max-width:900px;aspect-ratio:16/9;border:0;background:#000;';
		panel.allow = 'autoplay; fullscreen; picture-in-picture';
		panel.allowFullscreen = true;
	} else {
		panel = document.createElement('div');
		panel.style.cssText = 'width:90%;max-width:520px;background:#1f2329;color:#f3f4f6;border-radius:12px;' +
			'padding:24px;box-sizing:border-box;font:16px/1.5 system-ui,-apple-system,Segoe UI,sans-serif;';
		var h = document.createElement('h2');
		h.textContent = d.title;
		h.style.cssText = 'margin:0 0 12px;font-size:20px;';
		panel.appendChild(h);
		if (d.type === 'link') {
			var p = document.createElement('p');
			p.textContent = d.payload;
			p.style.cssText = 'word-break:break-all;opacity:.75;margin:0 0 16px;';
			panel.appendChild(p);
			var a = document.createElement('a');
			a.href = d.payload;
			a.target = '_blank';
			a.rel = 'noopener';
			a.textContent = 'Open in a new tab';
			a.style.cssText = 'display:inline-block;background:#38a3e4;color:#fff;text-decoration:none;' +
				'padding:10px 16px;border-radius:8px;';
			panel.appendChild(a);
		} else {
			var t = document.createElement('p');
			t.textContent = d.payload;
			t.style.cssText = 'white-space:pre-wrap;margin:0;';
			panel.appendChild(t);
		}
	}

	var close = document.createElement('button');
	close.type = 'button';
	close.setAttribute('aria-label', 'Close');
	close.textContent = '✕';
	close.style.cssText = 'position:fixed;top:12px;right:12px;width:44px;height:44px;border:0;border-radius:22px;' +
		'background:rgba(255,255,255,.15);color:#fff;font-size:20px;cursor:pointer;';

	function closeIt() {
		document.removeEventListener('keydown', onKey, true);
		wrap.remove();
		window.__tw_overlay_open = false;
		window.__tw_close = null;
		var c = document.getElementById('canvas');
		if (c) { c.focus(); }
	}
	function onKey(e) {
		if (e.key === 'Escape') { e.stopPropagation(); e.preventDefault(); closeIt(); }
	}
	document.addEventListener('keydown', onKey, true);
	wrap.addEventListener('click', function (e) { if (e.target === wrap) { closeIt(); } });
	close.addEventListener('click', closeIt);
	window.__tw_close = closeIt;

	wrap.appendChild(panel);
	wrap.appendChild(close);
	document.body.appendChild(wrap);
})();
]==]

--- Open an overlay for a content item (see content.lua).
function M.open(item)
	if is_open then
		return
	end
	is_open = true
	if html5 then
		local data = json.encode({ type = item.type, payload = item.payload, title = item.title or item.prompt })
		local js = JS:gsub("TW_DATA", function() return data end)
		html5.run(js)
	else
		print(("[overlay] %s: %s  (simulated outside HTML5, press Escape to close)"):format(item.type, item.payload))
	end
end

--- Close the overlay from Lua (Escape handling in the editor, or programmatic close).
function M.close()
	if not is_open then
		return
	end
	is_open = false
	if html5 then
		html5.run("window.__tw_close && window.__tw_close();")
	end
end

--- Call once per frame. Detects the overlay being closed from the DOM side.
function M.update()
	if is_open and html5 then
		if html5.run("String(!!window.__tw_overlay_open)") ~= "true" then
			is_open = false
		end
	end
end

--- @return boolean true while an overlay is open and game input should be ignored
function M.is_open()
	return is_open
end

return M
